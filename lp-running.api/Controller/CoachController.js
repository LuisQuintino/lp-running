const Coach = require('../Models/Coach');


exports.getAllCoaches = async (req, res) => {
  try {
    const coaches = await Coach.findAll(); 
    res.status(200).json(coaches); 
  } catch (error) {
    console.error("Erro ao buscar coaches:", error.message);
    res.status(500).json({ error: 'Erro ao buscar coaches.' });
  }
};
