const mongoose = require('mongoose');

const resetTokenSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'Coach', required: true }, // Referência ao Coach
  token: { type: String, required: true },
  createdAt: { type: Date, default: Date.now, expires: 3600 } // Token expira em 1 hora
});

module.exports = mongoose.model('ResetToken', resetTokenSchema);
