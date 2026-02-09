// app.test.js
const request = require('supertest');

const app = require('./app');

describe('Test the root path', () => {
    test('It should respond to the GET method', async () => {
        const response = await request(app).get('/');
        expect(response.statusCode).toBe(200);
        expect(response.text).toBe('DevOps Labs!');
    });
});

describe('Test the /name/:name path', () => {
    test('It should respond with a personalized greeting', async () => {
        const name = 'Alice';
        const response = await request(app).get(`/name/${name}`);
        expect(response.statusCode).toBe(200);
        expect(response.text).toBe(`Hello, ${name}!`);
    });
});

describe('Test the /add/:a/:b path', () => {
  test('It should return the sum for valid numbers', async () => {
    const response = await request(app).get('/add/2/3');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('5');
  });

  test('It should work with negative numbers', async () => {
    const response = await request(app).get('/add/-10/4');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('-6');
  });

  test('It should return 400 for invalid inputs', async () => {
    const response = await request(app).get('/add/abc/3');
    expect(response.statusCode).toBe(400);
    expect(response.text).toBe('Invalid numbers');
  });
});

const { formatName } = require('./utils');

describe('formatName', () => {
  test('trims spaces', () => {
    expect(formatName('  Theo ')).toBe('Theo');
  });

  test('returns null for empty', () => {
    expect(formatName('   ')).toBeNull();
  });
});