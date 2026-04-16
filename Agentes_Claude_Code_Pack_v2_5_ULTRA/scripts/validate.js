#!/usr/bin/env node

/**
 * Agent Catalog Validator
 *
 * Validates all agent files in the catalog:
 * 1. Checks for required sections (MISIÓN, DEBE HACER, NO DEBE HACER, DEFINICIÓN DE DONE)
 * 2. Validates COORDINA CON references point to existing agents
 * 3. Reports warnings for missing recommended sections
 *
 * Usage: node scripts/validate.js [--fix] [--verbose]
 */

const fs = require('fs');
const path = require('path');

// Configuration
const AGENTS_DIR = path.join(__dirname, '..', 'agents');
const INDEX_FILE = path.join(__dirname, '..', 'index.json');

const REQUIRED_SECTIONS = ['MISIÓN', 'DEBE HACER', 'NO DEBE HACER', 'DEFINICIÓN DE DONE'];
const RECOMMENDED_SECTIONS = [
  'ROL EN EL EQUIPO', 'ALCANCE', 'ENTRADAS', 'SALIDAS',
  'COORDINA CON', 'EJEMPLOS', 'MÉTRICAS DE ÉXITO', 'MODOS DE FALLA'
];

// Files/folders to exclude from validation (not agents, but policy/index files)
const EXCLUDE_PATTERNS = [
  /^global\//,  // Global folder contains policy files, not agents
  /index\.txt$/
];

// ANSI colors for terminal output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
  bold: '\x1b[1m'
};

// Stats
const stats = {
  totalAgents: 0,
  validAgents: 0,
  errors: 0,
  warnings: 0,
  brokenReferences: 0
};

/**
 * Recursively find all .txt files in a directory
 */
function findAgentFiles(dir, files = []) {
  const items = fs.readdirSync(dir);

  for (const item of items) {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      findAgentFiles(fullPath, files);
    } else if (item.endsWith('.txt')) {
      files.push(fullPath);
    }
  }

  return files;
}

/**
 * Extract agent name from filename
 */
function getAgentName(filePath) {
  return path.basename(filePath, '.txt');
}

/**
 * Build a map of all valid agent names
 */
function buildAgentIndex(files) {
  const index = new Map();

  for (const file of files) {
    const name = getAgentName(file);
    index.set(name.toLowerCase(), { name, path: file });
  }

  return index;
}

/**
 * Parse an agent file and extract sections
 */
function parseAgentFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.split('\n');

  const sections = {};
  let currentSection = null;
  let currentContent = [];

  for (const line of lines) {
    // Check if line is a section header (ALL CAPS, possibly with special chars)
    const sectionMatch = line.match(/^([A-ZÁÉÍÓÚÑÜ][A-ZÁÉÍÓÚÑÜ\s&\-]+)$/);

    if (sectionMatch) {
      // Save previous section
      if (currentSection) {
        sections[currentSection] = currentContent.join('\n').trim();
      }
      currentSection = sectionMatch[1].trim();
      currentContent = [];
    } else if (currentSection) {
      currentContent.push(line);
    }
  }

  // Save last section
  if (currentSection) {
    sections[currentSection] = currentContent.join('\n').trim();
  }

  return { content, sections };
}

/**
 * Extract agent references from COORDINA CON section
 */
function extractReferences(coordinaContent) {
  if (!coordinaContent) return [];

  const references = [];
  const lines = coordinaContent.split('\n');

  for (const line of lines) {
    // Match patterns like "- Agent Name Agent:" or "- Agent Name Agent,"
    const match = line.match(/^-\s*([^:,]+(?:Agent|Steward)[^:,]*)/i);
    if (match) {
      const ref = match[1].trim();
      // Clean up the reference
      const cleanRef = ref.replace(/\.$/, '').trim();
      if (cleanRef) {
        references.push(cleanRef);
      }
    }
  }

  return references;
}

/**
 * Find the best match for a reference in the agent index
 */
function findAgentMatch(reference, agentIndex) {
  const refLower = reference.toLowerCase();

  // Exact match
  if (agentIndex.has(refLower)) {
    return agentIndex.get(refLower);
  }

  // Try without " Agent" suffix
  const withoutSuffix = refLower.replace(/ agent$/, '');
  for (const [key, value] of agentIndex) {
    if (key.includes(withoutSuffix)) {
      return value;
    }
  }

  return null;
}

/**
 * Validate a single agent file
 */
function validateAgent(filePath, agentIndex, verbose) {
  const agentName = getAgentName(filePath);
  const relativePath = path.relative(AGENTS_DIR, filePath);
  const { sections } = parseAgentFile(filePath);

  const errors = [];
  const warnings = [];

  // Check required sections
  for (const section of REQUIRED_SECTIONS) {
    if (!sections[section]) {
      errors.push(`Missing required section: ${section}`);
    }
  }

  // Check recommended sections
  for (const section of RECOMMENDED_SECTIONS) {
    if (!sections[section]) {
      warnings.push(`Missing recommended section: ${section}`);
    }
  }

  // Validate COORDINA CON references
  const coordinaSection = sections['COORDINA CON'];
  if (coordinaSection) {
    const references = extractReferences(coordinaSection);

    for (const ref of references) {
      const match = findAgentMatch(ref, agentIndex);
      if (!match) {
        errors.push(`Broken reference in COORDINA CON: "${ref}"`);
        stats.brokenReferences++;
      }
    }
  }

  // Report results
  const hasErrors = errors.length > 0;
  const hasWarnings = warnings.length > 0;

  if (hasErrors || (verbose && hasWarnings)) {
    console.log(`\n${colors.bold}${relativePath}${colors.reset}`);

    for (const error of errors) {
      console.log(`  ${colors.red}✗ ERROR: ${error}${colors.reset}`);
      stats.errors++;
    }

    if (verbose) {
      for (const warning of warnings) {
        console.log(`  ${colors.yellow}⚠ WARNING: ${warning}${colors.reset}`);
        stats.warnings++;
      }
    }
  }

  return !hasErrors;
}

/**
 * Main validation function
 */
function main() {
  const args = process.argv.slice(2);
  const verbose = args.includes('--verbose') || args.includes('-v');

  console.log(`${colors.bold}${colors.cyan}=== Agent Catalog Validator ===${colors.reset}\n`);

  // Find all agent files
  const allFiles = findAgentFiles(AGENTS_DIR);

  // Filter out excluded files (global policy files, index, etc.)
  const agentFiles = allFiles.filter(file => {
    const relativePath = path.relative(AGENTS_DIR, file);
    return !EXCLUDE_PATTERNS.some(pattern => pattern.test(relativePath));
  });

  stats.totalAgents = agentFiles.length;

  console.log(`Found ${colors.bold}${agentFiles.length}${colors.reset} agent files (excluded ${allFiles.length - agentFiles.length} non-agent files)\n`);

  // Build agent index
  const agentIndex = buildAgentIndex(agentFiles);

  // Validate each agent
  for (const file of agentFiles) {
    const isValid = validateAgent(file, agentIndex, verbose);
    if (isValid) {
      stats.validAgents++;
    }
  }

  // Print summary
  console.log(`\n${colors.bold}${colors.cyan}=== Summary ===${colors.reset}`);
  console.log(`Total agents: ${stats.totalAgents}`);
  console.log(`${colors.green}Valid agents: ${stats.validAgents}${colors.reset}`);

  if (stats.errors > 0) {
    console.log(`${colors.red}Errors: ${stats.errors}${colors.reset}`);
  }

  if (stats.brokenReferences > 0) {
    console.log(`${colors.red}Broken references: ${stats.brokenReferences}${colors.reset}`);
  }

  if (verbose && stats.warnings > 0) {
    console.log(`${colors.yellow}Warnings: ${stats.warnings}${colors.reset}`);
  }

  // Exit with appropriate code
  const exitCode = stats.errors > 0 ? 1 : 0;

  if (exitCode === 0) {
    console.log(`\n${colors.green}${colors.bold}✓ All agents are valid!${colors.reset}`);
  } else {
    console.log(`\n${colors.red}${colors.bold}✗ Validation failed with ${stats.errors} error(s)${colors.reset}`);
  }

  process.exit(exitCode);
}

// Run
main();
