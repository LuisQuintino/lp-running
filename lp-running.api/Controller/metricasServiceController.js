const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

let metricas = []; // Lista para armazenar as métricas

// Rota para criar uma nova métrica
app.post('/metricas', (req, res) => {
    const { tempo, codigoAluno, descricao } = req.body;

    // Validação: todos os campos são obrigatórios
    if (!tempo || !codigoAluno || !descricao) {
        return res.status(400).json({ error: 'Todos os campos são obrigatórios.' });
    }

    // Cria uma nova métrica
    const novaMetrica = {
        id: metricas.length + 1,
        tempo: tempo,
        codigoAluno: codigoAluno,
        descricao: descricao
    };

    // Adiciona a nova métrica na lista
    metricas.push(novaMetrica);

    // Resposta de sucesso
    return res.status(201).json({ message: 'Métrica cadastrada com sucesso!', metrica: novaMetrica });
});

// Rota para atualizar a descrição de uma métrica existente
app.put('/metricas/:id', (req, res) => {
    const metricaId = parseInt(req.params.id, 10);
    const { descricao } = req.body;

    // Procura a métrica pelo ID
    const metrica = metricas.find(m => m.id === metricaId);

    // Verifica se a métrica existe
    if (!metrica) {
        return res.status(404).json({ error: 'Métrica não encontrada.' });
    }

    // Valida se a nova descrição foi enviada
    if (!descricao) {
        return res.status(400).json({ error: 'A descrição é obrigatória.' });
    }

    // Atualiza a descrição da métrica
    metrica.descricao = descricao;

    // Resposta de sucesso
    return res.status(200).json({ message: 'Descrição atualizada com sucesso!', metrica });
});

// Rota para deletar uma métrica pelo ID
app.delete('/metricas/:id', (req, res) => {
    const metricaId = parseInt(req.params.id, 10);

    // Procura o índice da métrica a ser removida
    const metricaIndex = metricas.findIndex(m => m.id === metricaId);

    // Verifica se a métrica existe
    if (metricaIndex === -1) {
        return res.status(404).json({ error: 'Métrica não encontrada.' });
    }

    // Remove a métrica da lista
    metricas.splice(metricaIndex, 1);

    // Resposta de sucesso
    return res.status(200).json({ message: 'Métrica deletada com sucesso!' });
});

// Configuração da porta do servidor
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
