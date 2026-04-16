#!/usr/bin/env node

/**
 * Agent Generator CLI
 *
 * Interactive CLI to create new agents from the template.
 *
 * Usage: node scripts/new-agent.js
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Configuration
const TEMPLATE_PATH = path.join(__dirname, '..', 'templates', 'agent-template.txt');
const AGENTS_DIR = path.join(__dirname, '..', 'agents');
const INDEX_PATH = path.join(__dirname, '..', 'index.json');

// Available categories (from index.json)
const CATEGORIES = [
  'web',
  'mobile',
  'desktop',
  'backend',
  'architecture',
  'cloud',
  'devops',
  'testing',
  'security',
  'data',
  'integrations',
  'transversal'
];

// ANSI colors
const colors = {
  reset: '\x1b[0m',
  bold: '\x1b[1m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m',
  red: '\x1b[31m'
};

/**
 * Create readline interface
 */
function createInterface() {
  return readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });
}

/**
 * Prompt user for input
 */
function prompt(rl, question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer.trim());
    });
  });
}

/**
 * Display menu and get selection
 */
async function selectCategory(rl) {
  console.log(`\n${colors.cyan}Categorías disponibles:${colors.reset}`);
  CATEGORIES.forEach((cat, index) => {
    console.log(`  ${index + 1}. ${cat}`);
  });

  const selection = await prompt(rl, `\nSelecciona categoría (1-${CATEGORIES.length}): `);
  const index = parseInt(selection) - 1;

  if (index >= 0 && index < CATEGORIES.length) {
    return CATEGORIES[index];
  }

  console.log(`${colors.red}Selección inválida. Usando 'transversal'.${colors.reset}`);
  return 'transversal';
}

/**
 * Validate agent name
 */
function validateAgentName(name) {
  if (!name || name.length < 3) {
    return 'El nombre debe tener al menos 3 caracteres';
  }

  if (!name.endsWith('Agent')) {
    return 'El nombre debe terminar en "Agent"';
  }

  // Check for invalid characters
  if (!/^[a-zA-Z0-9\s&\-]+$/.test(name)) {
    return 'El nombre solo puede contener letras, números, espacios, & y -';
  }

  return null;
}

/**
 * Check if agent already exists
 */
function agentExists(name, category) {
  const filename = `${name}.txt`;
  const filepath = path.join(AGENTS_DIR, category, filename);
  return fs.existsSync(filepath);
}

/**
 * Create agent file from template
 */
function createAgentFile(name, category, mission) {
  // Read template
  let template = fs.readFileSync(TEMPLATE_PATH, 'utf-8');

  // Replace placeholders
  template = template.replace('[Nombre del Agente]', name);
  template = template.replace(
    '[Describe en 1-2 oraciones el propósito principal del agente. Usa verbos en infinitivo.]',
    mission || '[TODO: Describe la misión del agente]'
  );

  // Ensure category directory exists
  const categoryDir = path.join(AGENTS_DIR, category);
  if (!fs.existsSync(categoryDir)) {
    fs.mkdirSync(categoryDir, { recursive: true });
  }

  // Write file
  const filename = `${name}.txt`;
  const filepath = path.join(categoryDir, filename);
  fs.writeFileSync(filepath, template);

  return filepath;
}

/**
 * Update index.json with new agent
 */
function updateIndex(name, category) {
  const index = JSON.parse(fs.readFileSync(INDEX_PATH, 'utf-8'));
  const filename = `${name}.txt`;

  // Find the category in platforms
  if (index.platforms && index.platforms[category]) {
    const agents = index.platforms[category].agents;

    // Check if already exists
    if (!agents.includes(filename)) {
      agents.push(filename);
      agents.sort();

      // Update agent count
      index.platforms[category].agent_count = agents.length;

      // Update total count
      if (index.agent_count_summary) {
        index.agent_count_summary.total_unique_agents++;
        if (index.agent_count_summary.by_category[category]) {
          index.agent_count_summary.by_category[category]++;
        }
      }

      // Write back
      fs.writeFileSync(INDEX_PATH, JSON.stringify(index, null, 2) + '\n');
      return true;
    }
  }

  return false;
}

/**
 * Main function
 */
async function main() {
  console.log(`${colors.bold}${colors.cyan}=== Agent Generator ===${colors.reset}\n`);

  // Check template exists
  if (!fs.existsSync(TEMPLATE_PATH)) {
    console.error(`${colors.red}Error: Template not found at ${TEMPLATE_PATH}${colors.reset}`);
    process.exit(1);
  }

  const rl = createInterface();

  try {
    // Get agent name
    let name;
    let validationError;

    do {
      name = await prompt(rl, `${colors.bold}Nombre del agente${colors.reset} (debe terminar en "Agent"): `);
      validationError = validateAgentName(name);

      if (validationError) {
        console.log(`${colors.red}${validationError}${colors.reset}`);
      }
    } while (validationError);

    // Get category
    const category = await selectCategory(rl);

    // Check if exists
    if (agentExists(name, category)) {
      console.log(`\n${colors.red}Error: El agente "${name}" ya existe en la categoría "${category}"${colors.reset}`);
      rl.close();
      process.exit(1);
    }

    // Get mission (optional)
    const mission = await prompt(rl, `\n${colors.bold}Misión${colors.reset} (1-2 oraciones, Enter para skip): `);

    // Confirm
    console.log(`\n${colors.yellow}Resumen:${colors.reset}`);
    console.log(`  Nombre: ${name}`);
    console.log(`  Categoría: ${category}`);
    console.log(`  Misión: ${mission || '[TODO]'}`);

    const confirm = await prompt(rl, `\n¿Crear agente? (s/n): `);

    if (confirm.toLowerCase() !== 's' && confirm.toLowerCase() !== 'si') {
      console.log('Cancelado.');
      rl.close();
      process.exit(0);
    }

    // Create agent
    const filepath = createAgentFile(name, category, mission);
    console.log(`\n${colors.green}✓ Agente creado: ${filepath}${colors.reset}`);

    // Update index
    const indexUpdated = updateIndex(name, category);
    if (indexUpdated) {
      console.log(`${colors.green}✓ index.json actualizado${colors.reset}`);
    } else {
      console.log(`${colors.yellow}⚠ No se pudo actualizar index.json (verifica manualmente)${colors.reset}`);
    }

    // Next steps
    console.log(`\n${colors.cyan}Próximos pasos:${colors.reset}`);
    console.log(`  1. Edita ${filepath}`);
    console.log(`  2. Completa todas las secciones [TODO]`);
    console.log(`  3. Ejecuta: node scripts/validate.js`);
    console.log(`  4. Crea un PR con los cambios`);

    rl.close();

  } catch (error) {
    console.error(`${colors.red}Error: ${error.message}${colors.reset}`);
    rl.close();
    process.exit(1);
  }
}

// Run
main();
