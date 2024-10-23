
const Aluno = require('../Models/Aluno');


exports.getAlunos = async (req, res) => {
  const { professor, nome, email } = req.query;
  const query = {};

  if (professor) {
    query.professor = professor;
  }
  if (nome) {
    query.nome = { [Op.like]: `%${nome}%` }; 
  }
  if (email) {
    query.email = email;
  }

  try {
    const alunos = await Aluno.findAll({
      where: query,
      include: { model: Professor, as: 'professor' }, 
    });
    res.status(200).json(alunos);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar alunos', error });
  }
};

// HttpPost - Criar Aluno
exports.createAluno = async (req, res) => {
  const { nome, email, professor } = req.body;

  try {
    const novoAluno = await Aluno.create({ nome, email, professor });
    res.status(201).json(novoAluno);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao criar aluno', error });
  }
};

// HttpPut - Atualizar Aluno
exports.updateAluno = async (req, res) => {
  const { id } = req.params;
  const { nome, email, professor } = req.body;

  try {
    const alunoAtualizado = await Aluno.update(
      { nome, email, professor },
      { where: { id }, returning: true, plain: true }
    );
    res.status(200).json(alunoAtualizado[1]); // Retorna o aluno atualizado
  } catch (error) {
    res.status(500).json({ message: 'Erro ao atualizar aluno', error });
  }
};

// HttpDelete - Atualizar aluno para a situação inativo
exports.inativarAluno = async (req, res) => {
  const { id } = req.params;

  try {
    const alunoInativado = await Aluno.update(
      { status: 'inativo' },
      { where: { id }, returning: true, plain: true }
    );
    res.status(200).json(alunoInativado[1]); // Retorna o aluno inativado
  } catch (error) {
    res.status(500).json({ message: 'Erro ao inativar aluno', error });
  }
};
