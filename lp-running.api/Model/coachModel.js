// Model/coachModel.js

const { sql } = require('../ApiConfig/db');

class Coach {
  static async getAll() {
    const result = await sql.query`SELECT * FROM Coaches`;
    return result.recordset;
  }

  static async getById(id) {
    const result = await sql.query`SELECT * FROM Coaches WHERE id = ${id}`;
    return result.recordset[0];
  }

  static async create(coach) {
    const { name, email, phone, cpf, dob, role, active } = coach;
    const result = await sql.query`
      INSERT INTO Coaches (name, email, phone, cpf, dob, role, active)
      VALUES (${name}, ${email}, ${phone}, ${cpf}, ${dob}, ${role}, ${active})
      SELECT SCOPE_IDENTITY() AS id
    `;
    return result.recordset[0].id;
  }

  static async update(id, coach) {
    const { name, email, phone, cpf, dob, role, active } = coach;
    await sql.query`
      UPDATE Coaches
      SET
        name = ${name},
        email = ${email},
        phone = ${phone},
        cpf = ${cpf},
        dob = ${dob},
        role = ${role},
        active = ${active},
        updated_at = GETDATE()
      WHERE id = ${id}
    `;
  }

  static async delete(id) {
    await sql.query`DELETE FROM Coaches WHERE id = ${id}`;
  }
}

module.exports = Coach;
