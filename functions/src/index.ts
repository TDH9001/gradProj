import * as firestore from 'firebase-functions/v2/firestore';
import * as admin from 'firebase-admin';

admin.initializeApp();

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
                    .doc(currentUserID)
                    .collection("Chats")
                    .doc(m)
                    .create({
                      chatID: ChatID,
                      name: userData.name,
                      phoneNumber : userData.PhoneNumber,
                      unseenCount: 1,
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
