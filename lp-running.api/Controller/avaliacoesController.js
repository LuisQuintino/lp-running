const Avaliacao = require('../Models/Avaliacao');

// Get
exports.getAvaliacoes = async (req, res) => {
    try {
        const avaliacoes = await Avaliacao.findAll(); // Retorna todas as avaliações
        res.status(200).json(avaliacoes);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar avaliações', error });
    }
};

// Create
exports.createAvaliacao = async (req, res) => {
    const { data, tempo, distancia, descricao, alunoId } = req.body;

    try {
        const novaAvaliacao = await Avaliacao.create({ data, tempo, distancia, descricao, alunoId });
        res.status(201).json(novaAvaliacao);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao criar avaliação', error });
    }
};

// Update
exports.updateAvaliacao = async (req, res) => {
    const { idAvaliacao } = req.params; 
    const { data, tempo, distancia, descricao, alunoId } = req.body;

    try {
        const [updated] = await Avaliacao.update(
            { data, tempo, distancia, descricao, alunoId },
            { where: { idAvaliacao }, returning: true } 
        );

        const updatedAvaliacao = await Avaliacao.findByPk(idAvaliacao); 
        res.status(200).json(updatedAvaliacao);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao atualizar avaliação', error });
    }
};

// Delete
exports.deleteAvaliacao = async (req, res) => {
    const { idAvaliacao } = req.params; 

    try {
        await Avaliacao.destroy({
            where: { idAvaliacao }
        });
        res.status(204).send();
    } catch (error) {
        res.status(500).json({ message: 'Erro ao deletar avaliação', error });
    }
};

// Get por ID
exports.findAvaliacaoById = async (req, res) => {
    const { idAvaliacao } = req.params;

    try {
        const avaliacao = await Avaliacao.findByPk(idAvaliacao); 
        res.status(200).json(avaliacao); 
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar avaliação', error });
    }
};
