module.exports = {
  apps: [{
    name: "sample-app",
    script: "./app.js",
    cwd: "/home/app-user",
    exec_mode: "cluster",
    instances: "max",
    env: {
      NODE_ENV: "production",
      PORT: 8080
    }
  }]
};
