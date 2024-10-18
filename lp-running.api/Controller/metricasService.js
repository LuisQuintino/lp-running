const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

let metricas = []; 

app.post('/metricas', (req, res) => {
    const { tempo, codigoAluno, descricao } = req.body;

    if (!tempo || !codigoAluno || !descricao) {
        return res.status(400).json({ error: 'Todos os campos são obrigatórios.' });
    }

    const novaMetrica = {
        id: metricas.length + 1,
        tempo: tempo,
        codigoAluno: codigoAluno,
        descricao: descricao
    };

    metricas.push(novaMetrica);
    return res.status(201).json({ message: 'Métrica cadastrada com sucesso!', metrica: novaMetrica });
});

app.put('/metricas/:id', (req, res) => {
    const metricaId = parseInt(req.params.id, 10);
    const { descricao } = req.body;

    const metrica = metricas.find(m => m.id === metricaId);

    if (!metrica) {
        return res.status(404).json({ error: 'Métrica não encontrada.' });
    }

    if (!descricao) {
        return res.status(400).json({ error: 'A descrição é obrigatória.' });
    }

    metrica.descricao = descricao;
    return res.status(200).json({ message: 'Descrição atualizada com sucesso!', metrica });
});

app.delete('/metricas/:id', (req, res) => {
    const metricaId = parseInt(req.params.id, 10);
    
    const metricaIndex = metricas.findIndex(m => m.id === metricaId);
    
    if (metricaIndex === -1) {
        return res.status(404).json({ error: 'Métrica não encontrada.' });
    }

    metricas.splice(metricaIndex, 1);
    return res.status(200).json({ message: 'Métrica deletada com sucesso!' });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
