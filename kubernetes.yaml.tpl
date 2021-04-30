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
          ports:
            - containerPort: 5000
          env:
            - name: FLASK_ENV
              value: staging
            - name: EQ_QUESTIONNAIRE_STATE_TABLE_NAME
              value: staging-author-runner-questionnaire-state
            - name: EQ_SESSION_TABLE_NAME
              value: staging-author-runner-session
            - name: EQ_USED_JTI_CLAIM_TABLE_NAME
              value: staging-author-runner-used-jti-claim
            - name: EQ_SUBMISSION_BACKEND
              value: log
            - name: EQ_FEEDBACK_BACKEND
              value: log
            - name: EQ_PUBLISHER_BACKEND
              value: log
            - name: EQ_STORAGE_BACKEND
              value: datastore
            - name: EQ_SECRETS_FILE
              value: dev-secrets.yml
            - name: EQ_KEYS_FILE
              value: dev-keys.yml
            - name: EQ_INDIVIDUAL_RESPONSE_POSTAL_DEADLINE
              value: 2021-04-28T14:00:00+00:00
            - name: ADDRESS_LOOKUP_API_URL
              value: https://whitelodge-ai-api.census-gcp.onsdigital.uk
            - name: EQ_SUBMISSION_CONFIRMATION_BACKEND
              value: log
            - name: EQ_ENABLE_SECURE_SESSION_COOKIE
              value: "True"
            - name: EQ_REDIS_HOST
              valueFrom:
                secretKeyRef:
                  name: author-runner-secrets
                  key: EQ_REDIS_HOST
            - name: EQ_REDIS_PORT
              valueFrom:
                secretKeyRef:
                  name: author-runner-secrets
                  key: EQ_REDIS_PORT

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
