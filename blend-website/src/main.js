import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import { initializeApp } from "firebase/app";

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

initializeApp(firebaseConfig);

createApp(App).use(store).use(router).mount('#app')
