import { createStore } from 'vuex'
import { initializeApp } from "firebase/app";
import {
    getFirestore,
    doc,
    setDoc,
    getDoc,
    getDocs,
    collection,
    addDoc,
    query,
    orderBy,
    where,
    updateDoc,
} from "firebase/firestore";

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyDmIaxkHWpEP0X8eYGEQ9YoPtFTtsYtcaM",
    authDomain: "barista-blend.firebaseapp.com",
    projectId: "barista-blend",
    storageBucket: "barista-blend.appspot.com",
    messagingSenderId: "438579021661",
    appId: "1:438579021661:web:2bcd8c49187dc8277a0ab4",
    measurementId: "G-PW10CEZGVE"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export default createStore({
    state: {
        workspace: {},
        blendCard: {},
    },
    getters: {
        workspace(state) {
            return state.workspace;
        },
        blendCard(state) {
            return state.blendCard;
        },
    },
    mutations: {
        setWorkspace(state, payload) {
            state.workspace = payload;
        },
        setBlendCard(state, payload) {
            state.blendCard = payload;
        },
    },
    actions: {
        async fetchWorkspace({ commit }, id) {
            const docRef = doc(db, `workspaces/${id}`);
            const docSnap = await getDoc(docRef);
            if (docSnap.exists()) {
                const docData = docSnap.data();
                commit("setWorkspace", docData);
                const blendCardSnap = await getDoc(docData.blendCard);
                if (blendCardSnap.exists()) {
                    commit("setBlendCard", blendCardSnap.data());
                } else {
                    console.log("No such document!");
                }

            } else {
                console.log("No such document!");
            }
        },
    },
})
