
## Installation
 1). Create an account at [Firebase](https://console.firebase.google.com/u/0/) and create a New project for your application.\
 3). Set up your Firebase Authentication sign-in methods. ---> [Firebase Auth](https://firebase.google.com/docs/auth)\
 4). Enable your Firebase Database. ---> [Database](https://firebase.google.com/docs/database)\
 5). Configure your Database Settings.
  ```
 {
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
 ```
 6). Enable your Firebase Storage. ---> [Storage](https://firebase.google.com/docs/storage)\
 7). Download `GoogleService-Info.plist` from your Firebase project and replace the existing file in your Xcode project.
 
 ## _License_
```
MIT License

Copyright (c) 2019 Vitaliy Paliy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
