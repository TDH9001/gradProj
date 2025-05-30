import * as firestore from 'firebase-functions/v2/firestore';
import * as admin from 'firebase-admin';

admin.initializeApp();
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
                      ChatAccesability:0,
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