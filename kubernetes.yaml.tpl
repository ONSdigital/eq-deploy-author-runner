# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

apiVersion: apps/v1
kind: Deployment
metadata:
  name: eq-author-runner
  labels:
    app: eq-author-runner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: eq-author-runner
  template:
    metadata:
      labels:
        app: eq-author-runner
    spec:
      containers:
        - name: eq-author-runner
          image: eu.gcr.io/GOOGLE_CLOUD_PROJECT/eq-author-runner:COMMIT_SHA
          envFrom:
          - secretRef:
              name: author-runner-secrets
          ports:
            - containerPort: 5000

---
kind: Service
apiVersion: v1
metadata:
  name: eq-author-runner
spec:
  selector:
    app: eq-author-runner
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer
