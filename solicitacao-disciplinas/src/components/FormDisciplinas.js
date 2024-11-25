import React, { useState } from "react";

const FormDisciplinas = ({ onSave }) => {
  const [form, setForm] = useState({
    responsavel: "",
    curso: "",
    grade: "",
    perfil: "",
    numeroVagasTotal: "",
    disciplinas: [],
  });

  const handleAddDisciplina = () => {
    setForm((prevForm) => ({
      ...prevForm,
      disciplinas: [
        ...prevForm.disciplinas,
        {
          disciplina: "",
          docente: "",
          vagasCalouros: "",
          horarios: [],
        },
      ],
    }));
  };

  const handleAddHorario = (index) => {
    const updatedDisciplinas = [...form.disciplinas];
    updatedDisciplinas[index].horarios.push({
      diaSemana: "",
      horarioInicio: "",
      horarioTermino: "",
    });
    setForm({ ...form, disciplinas: updatedDisciplinas });
  };

  const handleInputChange = (e, disciplinaIndex, horarioIndex, field) => {
    const { name, value } = e.target;
    if (disciplinaIndex !== undefined) {
      const updatedDisciplinas = [...form.disciplinas];
      if (horarioIndex !== undefined) {
        updatedDisciplinas[disciplinaIndex].horarios[horarioIndex][field] = value;
      } else {
        updatedDisciplinas[disciplinaIndex][name] = value;
      }
      setForm({ ...form, disciplinas: updatedDisciplinas });
    } else {
      setForm({ ...form, [name]: value });
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(form);
    setForm({
      responsavel: "",
      curso: "",
      grade: "",
      perfil: "",
      numeroVagasTotal: "",
      disciplinas: [],
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Solicitação de Disciplinas</h2>
      <div>
        <label>Responsável:</label>
        <input
          type="text"
          name="responsavel"
          value={form.responsavel}
          onChange={(e) => handleInputChange(e)}
        />
      </div>
      <div>
        <label>Curso:</label>
        <input
          type="text"
          name="curso"
          value={form.curso}
          onChange={(e) => handleInputChange(e)}
        />
      </div>
      <div>
        <label>Grade:</label>
        <input
          type="text"
          name="grade"
          value={form.grade}
          onChange={(e) => handleInputChange(e)}
        />
      </div>
      <div>
        <label>Perfil:</label>
        <input
          type="text"
          name="perfil"
          value={form.perfil}
          onChange={(e) => handleInputChange(e)}
        />
      </div>
      <div>
        <label>Número Total de Vagas:</label>
        <input
          type="number"
          name="numeroVagasTotal"
          value={form.numeroVagasTotal}
          onChange={(e) => handleInputChange(e)}
        />
      </div>

      <h3>Disciplinas</h3>
      {form.disciplinas.map((disciplina, i) => (
        <div key={i} style={{ border: "1px solid #ccc", margin: "10px 0", padding: "10px" }}>
          <label>Disciplina:</label>
          <input
            type="text"
            name="disciplina"
            value={disciplina.disciplina}
            onChange={(e) => handleInputChange(e, i)}
          />
          <label>Docente:</label>
          <input
            type="text"
            name="docente"
            value={disciplina.docente}
            onChange={(e) => handleInputChange(e, i)}
          />
          <label>Vagas para Calouros:</label>
          <input
            type="number"
            name="vagasCalouros"
            value={disciplina.vagasCalouros}
            onChange={(e) => handleInputChange(e, i)}
          />

          <h4>Horários</h4>
          {disciplina.horarios.map((horario, j) => (
            <div key={j}>
              <label>Dia da Semana:</label>
              <input
                type="text"
                value={horario.diaSemana}
                onChange={(e) => handleInputChange(e, i, j, "diaSemana")}
              />
              <label>Início:</label>
              <input
                type="time"
                value={horario.horarioInicio}
                onChange={(e) => handleInputChange(e, i, j, "horarioInicio")}
              />
              <label>Término:</label>
              <input
                type="time"
                value={horario.horarioTermino}
                onChange={(e) => handleInputChange(e, i, j, "horarioTermino")}
              />
            </div>
          ))}
          <button type="button" onClick={() => handleAddHorario(i)}>
            + Adicionar Horário
          </button>
        </div>
      ))}
      <button type="button" onClick={handleAddDisciplina}>
        + Adicionar Disciplina
      </button>
      <button type="submit">Salvar Solicitação</button>
    </form>
  );
};

export default FormDisciplinas;