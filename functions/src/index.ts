import * as firestore from 'firebase-functions/v2/firestore';
import * as admin from 'firebase-admin';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { Bucket } from '@google-cloud/storage';
import { GetFilesOptions } from "@google-cloud/storage";

admin.initializeApp();


const TWO_WEEKS_MS = 14 * 24 * 60 * 60 * 1000;

export const cleanupOldFiles = onSchedule(
  {
    schedule: 'every 24 hours',
    timeZone: 'Etc/UTC',
  },
  async (event) => {
    const bucket = admin.storage().bucket();
    const now = Date.now();

    const foldersToCheck = ['messageFiles of chats', 'voices']; // Adjust if necessary

    for (const folder of foldersToCheck) {
      console.log(`Scanning folder: ${folder}`);
      await scanFolderRecursive(bucket, folder, now);
    }

    return;
  }
);

async function scanFolderRecursive(
  bucket: Bucket,
  prefix: string,
  now: number,
  pageToken?: string
): Promise<void> {
  const [files, , nextQuery] = await bucket.getFiles({
    prefix,
    autoPaginate: false,
    pageToken,
  }) as [any[], any, GetFilesOptions?]; // 👈 explicitly type here

  for (const file of files) {
    const [metadata] = await file.getMetadata();
    const updatedRaw = metadata.updated ?? metadata.timeCreated;
    if (!updatedRaw) continue;

    const updatedTime = new Date(updatedRaw).getTime();

    if (now - updatedTime >= TWO_WEEKS_MS) {
      console.log(`Old file found: ${file.name} | Last updated: ${updatedRaw}`);
      // Optionally delete:
      await file.delete();
    }
  }

  const nextToken = nextQuery?.pageToken;
  if (nextToken) {
    await scanFolderRecursive(bucket, prefix, now, nextToken);
  }
}




//edit to satisfy your own needs as you DEVthe app
exports.onChatCreated = firestore.onDocumentCreated(
  "Chats/{chatID}",
  (event) => {
    const snapshot = event.data; // Firestore snapshot
    const ChatID = event.params.chatID;

    if (snapshot) {
      const data = snapshot.data();
      if (data) {
        const members: string[] = data.members;
        const ownerIDs : string[] = data.ownerID;

        for (let index = 0; index < members.length; index++) {
          const currentUserID = members[index];
          const remainingUserIDs = members.filter((u: string) => u !== currentUserID);

          remainingUserIDs.forEach((m: string) => {
            admin
              .firestore()
              .collection("Users")
              .doc(m)
              .get()
              .then((_doc) => {
                const userData = _doc.data();
                if (userData) {
                  return admin
                    .firestore()
                    .collection("Users")
                    .doc(currentUserID)
                    .collection("Chats")
                    .doc(ChatID)
                    .create({
                      chatID: ChatID,
                      name : ChatID,
                      senderName: userData.firstName.concat(" ",userData.lastName,),
                      unseenCount: 0,
                      admins:ownerIDs,
                      ChatAccesability:2,
                      temporaryScedule:null,
                      permanantScedules:null,
                      leaders:null
                    });
                }
                return null;
              })
              .catch(() => {
                return null;
              });
          });
        }
      }
    }
  }
);exports.onChatsUpdated = firestore.onDocumentUpdated(
  "Chats/{chatID}",
  async (event) => {
    const afterSnapshot = event.data?.after;
    const chatID = event.params.chatID;

    if (afterSnapshot) {
      const data = afterSnapshot.data();
      if (data) {
        const members: string[] = data.members;
        const lastMessage = data.messages[data.messages.length - 1];

        const updatePromises: Promise<void | FirebaseFirestore.WriteResult>[] = [];

        members.forEach((currentUserID) => {
          const updatePromise = admin
            .firestore()
            .collection("Users")
            .doc(currentUserID)
            .collection("Chats")
            .doc(chatID)
            .update({
              lastMessage: lastMessage.message,
              timestamp: lastMessage.timestamp,
              type: lastMessage.type,
              unseenCount: admin.firestore.FieldValue.increment(1), // ✅ Each user updates ONCE
              senderID: lastMessage.senderID,
              senderName: lastMessage.senderName,
              admins: data.ownerID,
              ChatAccesability: data.ChatAccesability,
              leaders: data.leaders

            })
            .catch((error) => {
              console.error(`Failed to update Chats for user ${currentUserID}:`, error);
            });

          updatePromises.push(updatePromise);
        });

        await Promise.all(updatePromises);
        console.log(`All Chats updated successfully for chatID: ${chatID}`);
      }
    }
  }
);