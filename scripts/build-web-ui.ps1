# build-web-ui.ps1
# Generates web/index.html with embedded agent data from agents/ directory

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

$basePath = "C:\Users\Machine\Documents\Proyect_IA\Agentic_configurations\Agentic_configurations"
$agentsPath = Join-Path $basePath "agents"
$outputPath = Join-Path $basePath "web\index.html"

# Category metadata
$categories = @{
    "_global" = @{ name = "Global"; icon = "globe"; platform = "multi" }
    "architecture" = @{ name = "Arquitectura"; icon = "layers"; platform = "multi" }
    "backend" = @{ name = "Backend"; icon = "server"; platform = "cloud" }
    "data" = @{ name = "Data"; icon = "database"; platform = "cloud" }
    "devops" = @{ name = "DevOps"; icon = "settings"; platform = "cloud" }
    "docs" = @{ name = "Documentacion"; icon = "book"; platform = "multi" }
    "integrations" = @{ name = "Integraciones"; icon = "link"; platform = "multi" }
    "operations" = @{ name = "Operaciones"; icon = "activity"; platform = "cloud" }
    "platform-cloud" = @{ name = "Cloud"; icon = "cloud"; platform = "cloud" }
    "platform-desktop" = @{ name = "Desktop"; icon = "monitor"; platform = "desktop" }
    "platform-mobile" = @{ name = "Mobile"; icon = "smartphone"; platform = "mobile" }
    "platform-web" = @{ name = "Web"; icon = "browser"; platform = "web" }
    "process" = @{ name = "Proceso"; icon = "git-branch"; platform = "multi" }
    "product" = @{ name = "Producto"; icon = "package"; platform = "multi" }
    "quality" = @{ name = "Calidad"; icon = "star"; platform = "multi" }
    "security" = @{ name = "Seguridad"; icon = "shield"; platform = "cloud" }
    "testing" = @{ name = "Testing"; icon = "check-circle"; platform = "multi" }
}

$categoryEmojis = @{
    "_global" = "globe"
    "architecture" = "building"
    "backend" = "server"
    "data" = "chart"
    "devops" = "gear"
    "docs" = "book"
    "integrations" = "link"
    "operations" = "activity"
    "platform-cloud" = "cloud"
    "platform-desktop" = "desktop"
    "platform-mobile" = "mobile"
    "platform-web" = "globe"
    "process" = "git"
    "product" = "box"
    "quality" = "star"
    "security" = "shield"
    "testing" = "check"
}

Write-Host "Reading agent files from: $agentsPath"

# Get all agent files
$agentFiles = Get-ChildItem -Path $agentsPath -Recurse -Filter "*.agent.txt"
Write-Host "Found $($agentFiles.Count) agent files"

# Build agents array
$agentsData = @()
foreach ($file in $agentFiles) {
    $category = $file.Directory.Name
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # Extract agent name from first line
    $lines = $content -split "`n"
    $firstLine = $lines[0].Trim()
    if ($firstLine -match "^AGENTE:\s*(.+)$") {
        $name = $Matches[1].Trim()
    } else {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name) -replace "\.agent$", ""
        $name = ($name -split "-" | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) }) -join " "
        $name = "$name Agent"
    }

    $platform = $categories[$category].platform
    if (-not $platform) { $platform = "multi" }

    # Escape content for JavaScript template literals
    # Replace backticks with \` and $ with \$ to avoid template literal interpolation
    $escapedContent = $content -replace '\\', '\\\\' -replace '`', '\`' -replace '\$', '\$'

    $agentsData += @{
        name = $name
        category = $category
        platform = $platform
        path = "agents/$category/$($file.Name)"
        config = $escapedContent
    }
}

# Sort by category then name
$agentsData = $agentsData | Sort-Object { $_.category }, { $_.name }

Write-Host "Building JavaScript data..."

# Generate JS agents array
$jsAgents = "const agents = [`n"
foreach ($agent in $agentsData) {
    $escapedName = $agent.name -replace "'", "\'"
    $jsAgents += "            { name: '$escapedName', category: '$($agent.category)', platform: '$($agent.platform)', path: '$($agent.path)', config: ``$($agent.config)`` },`n"
}
$jsAgents += "        ];"

Write-Host "Generating HTML file..."

# Generate the complete HTML
$html = @'
<!DOCTYPE html>
<html lang="es" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agent Catalog v3.0</title>
    <style>
        :root {
            --bg-primary: #0f172a;
            --bg-secondary: #1e293b;
            --bg-tertiary: #334155;
            --text-primary: #f1f5f9;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            --accent: #3b82f6;
            --accent-hover: #2563eb;
            --accent-light: #60a5fa;
            --success: #22c55e;
            --warning: #f59e0b;
            --danger: #ef4444;
            --border: #334155;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.4);
            --radius: 12px;
            --radius-sm: 8px;
        }
        [data-theme="light"] {
            --bg-primary: #f8fafc;
            --bg-secondary: #ffffff;
            --bg-tertiary: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #94a3b8;
            --border: #e2e8f0;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
        }
        .container { max-width: 1400px; margin: 0 auto; padding: 0 1.5rem; }

        /* Header */
        header {
            background: var(--bg-secondary);
            border-bottom: 1px solid var(--border);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .logo { display: flex; align-items: center; gap: 0.75rem; }
        .logo h1 {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent), var(--accent-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .header-stats { display: flex; gap: 1.5rem; color: var(--text-secondary); font-size: 0.875rem; }
        .stat { display: flex; align-items: center; gap: 0.5rem; }
        .stat-value { font-weight: 600; color: var(--accent); }
        .theme-toggle {
            background: var(--bg-tertiary);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 0.5rem 0.75rem;
            cursor: pointer;
            color: var(--text-primary);
            font-size: 1rem;
        }
        .theme-toggle:hover { background: var(--accent); color: white; }

        /* Search */
        .search-section { padding: 1.5rem 0; background: var(--bg-secondary); border-bottom: 1px solid var(--border); }
        .search-container { display: flex; gap: 1rem; flex-wrap: wrap; align-items: center; }
        .search-input {
            flex: 1;
            min-width: 250px;
            padding: 0.75rem 1rem;
            background: var(--bg-tertiary);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            color: var(--text-primary);
            font-size: 1rem;
        }
        .search-input:focus { outline: none; border-color: var(--accent); }
        .filter-select {
            padding: 0.75rem 1rem;
            background: var(--bg-tertiary);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            color: var(--text-primary);
            font-size: 0.875rem;
            min-width: 150px;
        }
        .results-count { color: var(--text-muted); font-size: 0.875rem; }

        /* Category Stats */
        .category-stats {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 0.75rem;
            padding: 1.5rem 0;
        }
        .category-stat {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 0.75rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .category-stat:hover { border-color: var(--accent); transform: translateY(-2px); }
        .category-stat.active { border-color: var(--accent); background: rgba(59, 130, 246, 0.1); }
        .category-stat-icon { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .category-stat-name { font-size: 0.75rem; color: var(--text-secondary); }
        .category-stat-count { font-size: 1rem; font-weight: 600; color: var(--accent); }

        /* Agents Grid */
        .agents-section { padding: 2rem 0; }
        .agents-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
        }
        .agent-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1.25rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .agent-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); border-color: var(--accent); }
        .agent-card-header { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem; }
        .agent-card-icon {
            width: 40px; height: 40px;
            border-radius: var(--radius-sm);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.25rem;
            background: var(--bg-tertiary);
        }
        .agent-card-title { font-weight: 600; font-size: 0.95rem; flex: 1; }
        .agent-card-meta { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .agent-tag {
            background: var(--bg-tertiary);
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.7rem;
            color: var(--text-secondary);
        }
        .agent-tag.platform { background: rgba(59, 130, 246, 0.2); color: var(--accent-light); }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.8);
            z-index: 1000;
            padding: 2rem;
            overflow-y: auto;
        }
        .modal.show { display: flex; justify-content: center; align-items: flex-start; }
        .modal-content {
            background: var(--bg-secondary);
            border-radius: var(--radius);
            max-width: 800px;
            width: 100%;
            max-height: 90vh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border);
        }
        .modal-title { font-size: 1.25rem; font-weight: 700; display: flex; align-items: center; gap: 0.75rem; }
        .modal-close {
            background: var(--bg-tertiary);
            border: none;
            border-radius: var(--radius-sm);
            padding: 0.5rem 0.75rem;
            cursor: pointer;
            color: var(--text-primary);
            font-size: 1rem;
        }
        .modal-close:hover { background: var(--danger); color: white; }
        .modal-body { padding: 1.5rem; overflow-y: auto; flex: 1; }
        .modal-config {
            background: var(--bg-primary);
            border-radius: var(--radius-sm);
            padding: 1.25rem;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.85rem;
            white-space: pre-wrap;
            line-height: 1.5;
            max-height: 60vh;
            overflow-y: auto;
        }
        .modal-footer {
            display: flex;
            gap: 0.75rem;
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            justify-content: flex-end;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--radius-sm);
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-primary { background: var(--accent); color: white; }
        .btn-primary:hover { background: var(--accent-hover); }
        .btn-success { background: var(--success); color: white; }

        /* Footer */
        footer {
            background: var(--bg-secondary);
            border-top: 1px solid var(--border);
            padding: 1.5rem 0;
            text-align: center;
            color: var(--text-muted);
            font-size: 0.875rem;
        }
        footer a { color: var(--accent); text-decoration: none; }
        footer a:hover { text-decoration: underline; }

        /* Responsive */
        @media (max-width: 768px) {
            .header-content { flex-direction: column; text-align: center; }
            .header-stats { justify-content: center; }
            .search-container { flex-direction: column; }
            .search-input, .filter-select { width: 100%; }
            .agents-grid { grid-template-columns: 1fr; }
            .category-stats { grid-template-columns: repeat(3, 1fr); }
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <h1>Agent Catalog v3.0</h1>
                </div>
                <div class="header-stats">
                    <div class="stat">Agentes: <span class="stat-value" id="total-count">0</span></div>
                    <div class="stat">Categorias: <span class="stat-value" id="category-count">0</span></div>
                </div>
                <button class="theme-toggle" onclick="toggleTheme()">&#x1F313;</button>
            </div>
        </div>
    </header>

    <div class="search-section">
        <div class="container">
            <div class="search-container">
                <input type="text" class="search-input" id="search" placeholder="Buscar agentes por nombre o contenido..." oninput="filterAgents()">
                <select class="filter-select" id="category-filter" onchange="filterAgents()">
                    <option value="">Todas las categorias</option>
                </select>
                <select class="filter-select" id="platform-filter" onchange="filterAgents()">
                    <option value="">Todas las plataformas</option>
                    <option value="web">Web</option>
                    <option value="mobile">Mobile</option>
                    <option value="desktop">Desktop</option>
                    <option value="cloud">Cloud</option>
                    <option value="multi">Multi</option>
                </select>
                <span class="results-count" id="results-count"></span>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="category-stats" id="category-stats"></div>
    </div>

    <section class="agents-section">
        <div class="container">
            <div class="agents-grid" id="agents-grid"></div>
        </div>
    </section>

    <footer>
        <div class="container">
            <p>Agent Catalog v3.0 ULTRA - <a href="https://github.com/AlexaieDev/Agentic_configurations" target="_blank">GitHub</a></p>
        </div>
    </footer>

    <div class="modal" id="modal" onclick="closeModal(event)">
        <div class="modal-content" onclick="event.stopPropagation()">
            <div class="modal-header">
                <div class="modal-title">
                    <span id="modal-icon">&#x1F916;</span>
                    <span id="modal-title">Agent Name</span>
                </div>
                <button class="modal-close" onclick="closeModal()">&#x2715;</button>
            </div>
            <div class="modal-body">
                <pre class="modal-config" id="modal-config"></pre>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" id="copy-btn" onclick="copyConfig()">&#x1F4CB; Copiar Configuracion</button>
            </div>
        </div>
    </div>

    <script>
        // ==================== DATA ====================

'@

$html += $jsAgents

$html += @'


        const categoryMeta = {
            "_global": { name: "Global", icon: String.fromCodePoint(0x1F310) },
            "architecture": { name: "Arquitectura", icon: String.fromCodePoint(0x1F3D7) },
            "backend": { name: "Backend", icon: String.fromCodePoint(0x2699) },
            "data": { name: "Data", icon: String.fromCodePoint(0x1F4CA) },
            "devops": { name: "DevOps", icon: String.fromCodePoint(0x1F527) },
            "docs": { name: "Documentacion", icon: String.fromCodePoint(0x1F4DA) },
            "integrations": { name: "Integraciones", icon: String.fromCodePoint(0x1F517) },
            "operations": { name: "Operaciones", icon: String.fromCodePoint(0x1F4C8) },
            "platform-cloud": { name: "Cloud", icon: String.fromCodePoint(0x2601) },
            "platform-desktop": { name: "Desktop", icon: String.fromCodePoint(0x1F5A5) },
            "platform-mobile": { name: "Mobile", icon: String.fromCodePoint(0x1F4F1) },
            "platform-web": { name: "Web", icon: String.fromCodePoint(0x1F30D) },
            "process": { name: "Proceso", icon: String.fromCodePoint(0x1F504) },
            "product": { name: "Producto", icon: String.fromCodePoint(0x1F4E6) },
            "quality": { name: "Calidad", icon: String.fromCodePoint(0x2B50) },
            "security": { name: "Seguridad", icon: String.fromCodePoint(0x1F512) },
            "testing": { name: "Testing", icon: String.fromCodePoint(0x2705) }
        };

        let currentAgent = null;
        let selectedCategory = '';

        // ==================== INITIALIZATION ====================
        function init() {
            document.getElementById('total-count').textContent = agents.length;

            // Get unique categories
            const categories = [...new Set(agents.map(a => a.category))].sort();
            document.getElementById('category-count').textContent = categories.length;

            // Populate category filter
            const categoryFilter = document.getElementById('category-filter');
            categories.forEach(cat => {
                const meta = categoryMeta[cat] || { name: cat, icon: "📁" };
                const option = document.createElement('option');
                option.value = cat;
                option.textContent = `${meta.icon} ${meta.name}`;
                categoryFilter.appendChild(option);
            });

            // Render category stats
            renderCategoryStats(categories);

            // Initial render
            renderAgents(agents);
        }

        function renderCategoryStats(categories) {
            const container = document.getElementById('category-stats');
            const counts = {};
            agents.forEach(a => {
                counts[a.category] = (counts[a.category] || 0) + 1;
            });

            container.innerHTML = categories.map(cat => {
                const meta = categoryMeta[cat] || { name: cat, icon: "📁" };
                return `
                    <div class="category-stat ${selectedCategory === cat ? 'active' : ''}" onclick="selectCategory('${cat}')">
                        <div class="category-stat-icon">${meta.icon}</div>
                        <div class="category-stat-count">${counts[cat]}</div>
                        <div class="category-stat-name">${meta.name}</div>
                    </div>
                `;
            }).join('');
        }

        function selectCategory(cat) {
            selectedCategory = selectedCategory === cat ? '' : cat;
            document.getElementById('category-filter').value = selectedCategory;
            filterAgents();

            // Update active state
            document.querySelectorAll('.category-stat').forEach(el => {
                el.classList.toggle('active', el.onclick.toString().includes(`'${selectedCategory}'`));
            });
        }

        function renderAgents(filteredAgents) {
            const container = document.getElementById('agents-grid');

            if (filteredAgents.length === 0) {
                container.innerHTML = '<p style="text-align: center; color: var(--text-muted); padding: 2rem;">No se encontraron agentes</p>';
                return;
            }

            container.innerHTML = filteredAgents.map((agent, index) => {
                const meta = categoryMeta[agent.category] || { name: agent.category, icon: "📁" };
                return `
                    <div class="agent-card" onclick="openModal(${index})">
                        <div class="agent-card-header">
                            <div class="agent-card-icon">${meta.icon}</div>
                            <div class="agent-card-title">${agent.name}</div>
                        </div>
                        <div class="agent-card-meta">
                            <span class="agent-tag">${meta.name}</span>
                            <span class="agent-tag platform">${agent.platform}</span>
                        </div>
                    </div>
                `;
            }).join('');

            document.getElementById('results-count').textContent = `${filteredAgents.length} agentes`;
        }

        function filterAgents() {
            const search = document.getElementById('search').value.toLowerCase().trim();
            const category = document.getElementById('category-filter').value;
            const platform = document.getElementById('platform-filter').value;

            selectedCategory = category;

            let filtered = agents.filter(agent => {
                const matchesSearch = !search ||
                    agent.name.toLowerCase().includes(search) ||
                    agent.config.toLowerCase().includes(search);
                const matchesCategory = !category || agent.category === category;
                const matchesPlatform = !platform || agent.platform === platform;

                return matchesSearch && matchesCategory && matchesPlatform;
            });

            renderAgents(filtered);

            // Update category stats active state
            document.querySelectorAll('.category-stat').forEach(el => {
                const catName = el.querySelector('.category-stat-name').textContent;
                const catKey = Object.keys(categoryMeta).find(k => categoryMeta[k].name === catName);
                el.classList.toggle('active', catKey === selectedCategory);
            });
        }

        function openModal(index) {
            const filtered = getFilteredAgents();
            currentAgent = filtered[index];

            const meta = categoryMeta[currentAgent.category] || { name: currentAgent.category, icon: "📁" };
            document.getElementById('modal-icon').textContent = meta.icon;
            document.getElementById('modal-title').textContent = currentAgent.name;
            document.getElementById('modal-config').textContent = currentAgent.config;
            document.getElementById('modal').classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function getFilteredAgents() {
            const search = document.getElementById('search').value.toLowerCase().trim();
            const category = document.getElementById('category-filter').value;
            const platform = document.getElementById('platform-filter').value;

            return agents.filter(agent => {
                const matchesSearch = !search ||
                    agent.name.toLowerCase().includes(search) ||
                    agent.config.toLowerCase().includes(search);
                const matchesCategory = !category || agent.category === category;
                const matchesPlatform = !platform || agent.platform === platform;

                return matchesSearch && matchesCategory && matchesPlatform;
            });
        }

        function closeModal(event) {
            if (event && event.target !== document.getElementById('modal')) return;
            document.getElementById('modal').classList.remove('show');
            document.body.style.overflow = '';
            currentAgent = null;
        }

        async function copyConfig() {
            if (!currentAgent) return;

            try {
                await navigator.clipboard.writeText(currentAgent.config);
                const btn = document.getElementById('copy-btn');
                btn.textContent = '\u2705 Copiado!';
                btn.classList.add('btn-success');
                btn.classList.remove('btn-primary');

                setTimeout(() => {
                    btn.textContent = '\uD83D\uDCCB Copiar Configuracion';
                    btn.classList.remove('btn-success');
                    btn.classList.add('btn-primary');
                }, 2000);
            } catch (err) {
                alert('No se pudo copiar. Intenta seleccionar el texto manualmente.');
            }
        }

        function toggleTheme() {
            const html = document.documentElement;
            const current = html.getAttribute('data-theme');
            html.setAttribute('data-theme', current === 'dark' ? 'light' : 'dark');
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') closeModal();
            if (e.key === '/' && !e.ctrlKey && !e.metaKey) {
                e.preventDefault();
                document.getElementById('search').focus();
            }
        });

        // Initialize
        init();
    </script>
</body>
</html>
'@

# Write to file with proper UTF-8 encoding (no BOM)
[System.IO.File]::WriteAllText($outputPath, $html, [System.Text.UTF8Encoding]::new($false))

Write-Host "`nGenerated: $outputPath"
Write-Host "Total agents embedded: $($agentsData.Count)"
Write-Host "Done!"
