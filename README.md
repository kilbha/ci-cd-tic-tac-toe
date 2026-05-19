# DevSecOps Pipeline Implementation for Tic Tac Toe Game

![Screenshot 2025-03-04 at 7 16 48 PM](https://github.com/user-attachments/assets/7ed79f9c-9144-4870-accd-500085a15592)

![image](https://github.com/user-attachments/assets/5b2813a5-f493-4665-8964-77359b5be93a)

## Features

- 🎮 Fully functional Tic Tac Toe game
- 📊 Score tracking for X, O, and draws
- 📜 Game history with timestamps
- 🏆 Highlights winning combinations
- 🔄 Reset game and statistics
- 📱 Responsive design for all devices

## Technologies Used

- React 18
- TypeScript
- Tailwind CSS
- Lucide React for icons

## Project Structure

```
src/
├── components/
│   ├── Board.tsx       # Game board component
│   ├── Square.tsx      # Individual square component
│   ├── ScoreBoard.tsx  # Score tracking component
│   └── GameHistory.tsx # Game history component
├── utils/
│   └── gameLogic.ts    # Game logic utilities
├── App.tsx             # Main application component
└── main.tsx           # Entry point
```

## Game Logic

The game implements the following rules:

1. X goes first, followed by O
2. The first player to get 3 of their marks in a row (horizontally, vertically, or diagonally) wins
3. If all 9 squares are filled and no player has 3 marks in a row, the game is a draw
4. Winning combinations are highlighted
5. Game statistics are tracked and displayed

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/devsecops-demo.git
   cd devsecops-demo
   ```

2. Install dependencies:
   ```bash
   npm install
   # or
   yarn
   ```

3. Start the development server:
   ```bash
   npm run dev
   # or
   yarn dev
   ```

4. Open your browser and navigate to `http://localhost:5173`

## Building for Production

To create a production build:

```bash
npm run build
# or
yarn build
```

The build artifacts will be stored in the `dist/` directory.



Add the following sections to your README.md after the **Building for Production** section.

# GitHub Actions OIDC Authentication with AWS

This project uses GitHub Actions OIDC authentication to securely access AWS resources without storing long-term AWS access keys in GitHub Secrets.

## Create OIDC Provider

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

---

## Create IAM Role for GitHub Actions

Create the IAM role using the trust policy file:

```bash
aws iam create-role \
  --role-name my-github-actions-role \
  --assume-role-policy-document file://trust-policy.json
```

---

## Attach IAM Policy to Role

`GitHubActionsECRPolicy.json` is available in the project root directory.

Create the policy:

```bash
aws iam create-policy \
  --policy-name GitHubActionsECRPolicy \
  --policy-document file://GitHubActionsECRPolicy.json
```

Attach the policy to the IAM role:

```bash
aws iam attach-role-policy \
  --role-name my-github-actions-role \
  --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/GitHubActionsECRPolicy
```

---

# GitHub Actions Secrets

Add the following GitHub repository secrets:

| Secret Name      | Description                     |
| ---------------- | ------------------------------- |
| AWS_REGION       | AWS Region                      |
| AWS_ACCOUNT_ID   | AWS Account ID                  |
| ECR_REPOSITORY   | ECR Repository Name             |
| EKS_CLUSTER_NAME | EKS Cluster Name                |
| AWS_ROLE_ARN     | IAM Role ARN for GitHub Actions |

---

# GitHub Actions Workflow Configuration

Update your GitHub Actions workflow to use OIDC authentication and assume the IAM role.

Example:

```yaml
permissions:
  id-token: write
  contents: read

- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    aws-region: ${{ secrets.AWS_REGION }}
```

Replace hardcoded AWS Account IDs and IAM role ARNs with GitHub Secrets wherever required.

---

# Kubernetes Secret for Pulling Images from Amazon ECR

Create a Kubernetes Docker registry secret to allow Kubernetes to pull private images from ECR.

```bash
kubectl create secret docker-registry ecr-regcred \
  --docker-server=045555583762.dkr.ecr.ap-south-2.amazonaws.com \
  --docker-username=AWS \
  --docker-password="$(aws ecr get-login-password --region ap-south-2)" \
  --docker-email=fake@example.com
```

Verify the secret:

```bash
kubectl get secret ecr-regcred
```

---

# Use Image Pull Secret in Deployment

Add the following section inside your Kubernetes Deployment manifest:

```yaml
spec:
  template:
    spec:
      imagePullSecrets:
        - name: ecr-regcred
```

This allows Kubernetes pods to authenticate with Amazon ECR and pull private container images securely.
