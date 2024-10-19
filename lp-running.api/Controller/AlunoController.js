const Aluno = require('../models/Aluno');

// HttpGet - Traz todos os alunos, podendo filtrar por professor, nome e e-mail
exports.getAlunos = async (req, res) => {
    const { professor, nome, email } = req.query;
    const query = {};

    if (professor) {
        query.professor = professor;
    }
    if (nome) {
        query.nome = { $regex: nome, $options: 'i' }; // Filtra por nome contendo o valor
    }
    if (email) {
        query.email = email;
    }

    try {
        const alunos = await Aluno.find(query).populate('professor'); // Popula com dados do Professor
        res.status(200).json(alunos);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar alunos', error });
    }
};

// HttpPost - Criar Aluno
exports.createAluno = async (req, res) => {
    const { nome, email, professor } = req.body;

    try {
        const novoAluno = new Aluno({ nome, email, professor });
        await novoAluno.save();
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
        const alunoAtualizado = await Aluno.findByIdAndUpdate(id, { nome, email, professor }, { new: true });
        res.status(200).json(alunoAtualizado);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao atualizar aluno', error });
    }
};

// HttpDelete - Atualizar aluno para a situação inativo
exports.inativarAluno = async (req, res) => {
    const { id } = req.params;

    try {
        const alunoInativado = await Aluno.findByIdAndUpdate(id, { status: 'inativo' }, { new: true });
        res.status(200).json(alunoInativado);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao inativar aluno', error });
    }
};
