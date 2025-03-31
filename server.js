const express = require('express');
const { createServer } = require('http');
const { Server } = require('socket.io');
const sequelize = require('./config/database');
const authRoutes = require('./routes/auth');
const paymentRoutes = require('./routes/payments');

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

// Database connection
sequelize.sync()
  .then(() => console.log('Database connected'))
  .catch(err => console.error(err));

// Middleware
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/payments', paymentRoutes);

// Socket.io
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);
  socket.on('chatMessage', (msg) => {
    io.emit('message', msg);
  });
});

// Start server
const PORT = process.env.PORT || 5000;
httpServer.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
