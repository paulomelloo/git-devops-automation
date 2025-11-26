const http = require('http');

const http = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello, FastAPI with Multistage Docker!\n');
});

const PORT = process.env.PORT || 3000;
http.listen(PORT, () => {
    console.log(`Servidor rodando http://localhost:${PORT}/`);
});
