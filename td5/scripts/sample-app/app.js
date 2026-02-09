const express = require('express');
const { formatName } = require('./utils');

const app = express();

app.get('/', (req, res) => {
  res.send('DevOps Labs!');
});

app.get('/name/:name', (req, res) => {
  const name = req.params.name;
  res.send(`Hello, ${name}!`);
});

app.get('/add/:a/:b', (req, res) => {
  const a = Number(req.params.a);
  const b = Number(req.params.b);

  if (!Number.isFinite(a) || !Number.isFinite(b)) {
    return res.status(400).send('Invalid numbers');
  }

  return res.send(String(a + b));
});

// fallback: si jamais / ne matche pas pour une raison bizarre
app.use((req, res) => {
  res.status(404).send('Not found');
});

module.exports = app;
