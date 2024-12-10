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
                    .doc(ChatID)
                    .collection("Chats")
                    .doc(m)
                    .create({
                      chatID: ChatID,
                      name : ChatID,
                      senderName: userData.firstName.concat(" ",userData.lastName,),
                      senderId: currentUserID,
                      unseenCount: 0,
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
);
exports.onChatsUpdated = firestore.onDocumentUpdated(
    "Chats/{chatID}",
    async (event) => {
      const afterSnapshot = event.data?.after; // Firestore snapshot after update
      const chatID = event.params.chatID;
  
      if (afterSnapshot) {
        const data = afterSnapshot.data();
        if (data) {
          const members: string[] = data.members;
          const lastMessage = data.messages[data.messages.length - 1];
  
          // Collect promises to ensure all updates are completed
          const updatePromises: Promise<void | FirebaseFirestore.WriteResult>[] = [];
  
          members.forEach((currentUserID) => {
            const remainingUserIDs = members.filter((u: string) => u !== currentUserID);
  
            remainingUserIDs.forEach((otherUserID) => {
              const updatePromise = admin
                .firestore()
                .collection("Users")
                .doc(currentUserID)
                .collection("Chats")
                .doc(otherUserID)
                .update({
                  lastMessage: lastMessage.message,
                  timestamp: lastMessage.timestamp,
                  type: lastMessage.type,
                  unseenCount: admin.firestore.FieldValue.increment(1),
                  sender: currentUserID
                })
                .catch((error) => {
                  console.error(
                    `Failed to update Chats for user ${currentUserID} with ${otherUserID}:`,
                    error
                  );
                });
  
              updatePromises.push(updatePromise);
            });
          });
  
          // Wait for all promises to complete
          await Promise.all(updatePromises);
          console.log(`All Chats updated successfully for chatID: ${chatID}`);
        }
      }
    }
  );