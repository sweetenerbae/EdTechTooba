
import {onCall} from "firebase-functions/v2/https";
import {onObjectFinalized} from "firebase-functions/v2/storage";
import {defineSecret} from "firebase-functions/params";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {getStorage} from "firebase-admin/storage";
import OpenAI from "openai";

initializeApp();

const REGION = "us-central1";
const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

// 1) Чат (callable)
export const askGPTCallable = onCall(
  {region: REGION, secrets: [OPENAI_API_KEY]},
  async (request) => {
    const client = new OpenAI({apiKey: OPENAI_API_KEY.value()});
    const prompt = String(request.data?.prompt ?? "").trim();
    if (!prompt) return {text: ""};

    const r = await client.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [{role: "user", content: prompt}],
      temperature: 0.2,
    });
    return {text: r.choices[0]?.message?.content ?? ""};
  }
);

// 2) OCR (Storage trigger)
export const ocrOnImageUpload = onObjectFinalized(
  {region: REGION, bucket: process.env.STORAGE_BUCKET},
  async (event) => {
    const filePath = event.data.name ?? "";
    const contentType = event.data.contentType ?? "";
    if (!contentType.startsWith("image/")) return;
    if (!filePath.startsWith("ocr_uploads/")) return;

    const taskId = filePath.split("/").pop()!.replace(/\.[^.]+$/, "");
    const db = getFirestore();
    const docRef = db.collection("ocr_tasks").doc(taskId);
    await docRef.set({status: "processing"}, {merge: true});

    const bucket = getStorage().bucket(event.data.bucket);
    const [signedUrl] = await bucket
      .file(filePath)
      .getSignedUrl({action: "read", expires: Date.now() + 10 * 60 * 1000});

    const client = new OpenAI({apiKey: OPENAI_API_KEY.value()});
    const r = await client.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        {
          role: "user",
          content: [
            {type: "text", text: "Извлеки весь читаемый текст без разметки."},
            {type: "image_url", image_url: {url: signedUrl}},
          ],
        },
      ],
      temperature: 0.2,
    });

    const text = r.choices[0]?.message?.content ?? "";
    await docRef.set({status: "done", resultText: text}, {merge: true});
  }
);
