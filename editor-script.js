// Editor functionality
document.addEventListener('DOMContentLoaded', function() {
    // Check if user is logged in
    checkAuthentication();
    
    // Initialize editor
    initializeEditor();
    
    // Update line numbers
    updateLineNumbers();
});

// Authentication check
function checkAuthentication() {
    const isLoggedIn = sessionStorage.getItem('vyron_logged_in');
    const username = sessionStorage.getItem('vyron_username');
    
    if (!isLoggedIn || !username) {
        // Redirect to login page
        window.location.href = 'index.html';
        return;
    }
    
    // Update UI with user info
    console.log(`Welcome back, ${username}!`);
}

// Logout function
function logout() {
    sessionStorage.removeItem('vyron_logged_in');
    sessionStorage.removeItem('vyron_username');
    sessionStorage.removeItem('vyron_script_key');
    window.location.href = 'index.html';
}

// File management
function selectFile(element, filename) {
    // Remove active class from all files
    document.querySelectorAll('.file-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Add active class to selected file
    element.classList.add('active');
    
    // Update tab
    const tab = document.querySelector('.tab span');
    tab.textContent = filename;
    
    // Load file content (simulate)
    loadFileContent(filename);
}

function loadFileContent(filename) {
    const editor = document.getElementById('codeEditor');
    
    // Sample content for different files
    const fileContents = {
        'main.lua': `<div class="code-line"><span class="lua-comment">-- Vyron Internal Main Script</span></div>
<div class="code-line"><span class="lua-keyword">local</span> <span class="lua-variable">player</span> <span class="lua-operator">=</span> <span class="lua-function">game</span><span class="lua-operator">:</span><span class="lua-method">GetService</span><span class="lua-bracket">(</span><span class="lua-string">"Players"</span><span class="lua-bracket">)</span><span class="lua-operator">.</span><span class="lua-property">LocalPlayer</span></div>
<div class="code-line"><span class="lua-keyword">local</span> <span class="lua-variable">mouse</span> <span class="lua-operator">=</span> <span class="lua-variable">player</span><span class="lua-operator">:</span><span class="lua-method">GetMouse</span><span class="lua-bracket">()</span></div>
<div class="code-line"></div>
<div class="code-line"><span class="lua-keyword">function</span> <span class="lua-function">onKeyPress</span><span class="lua-bracket">(</span><span class="lua-variable">key</span><span class="lua-bracket">)</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-keyword">if</span> <span class="lua-variable">key</span> <span class="lua-operator">==</span> <span class="lua-string">"e"</span> <span class="lua-keyword">then</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-function">print</span><span class="lua-bracket">(</span><span class="lua-string">"Vyron Internal Activated!"</span><span class="lua-bracket">)</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-keyword">end</span></div>
<div class="code-line"><span class="lua-keyword">end</span></div>
<div class="code-line"></div>
<div class="code-line"><span class="lua-variable">mouse</span><span class="lua-operator">.</span><span class="lua-property">KeyDown</span><span class="lua-operator">:</span><span class="lua-method">Connect</span><span class="lua-bracket">(</span><span class="lua-variable">onKeyPress</span><span class="lua-bracket">)</span></div>`,
        
        'config.lua': `<div class="code-line"><span class="lua-comment">-- Vyron Internal Configuration</span></div>
<div class="code-line"><span class="lua-keyword">local</span> <span class="lua-variable">config</span> <span class="lua-operator">=</span> <span class="lua-bracket">{</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-property">enabled</span> <span class="lua-operator">=</span> <span class="lua-keyword">true</span><span class="lua-operator">,</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-property">keybind</span> <span class="lua-operator">=</span> <span class="lua-string">"e"</span><span class="lua-operator">,</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-property">speed</span> <span class="lua-operator">=</span> <span class="lua-number">16</span><span class="lua-operator">,</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-property">jumpPower</span> <span class="lua-operator">=</span> <span class="lua-number">50</span></div>
<div class="code-line"><span class="lua-bracket">}</span></div>
<div class="code-line"></div>
<div class="code-line"><span class="lua-keyword">return</span> <span class="lua-variable">config</span></div>`,
        
        'utils.lua': `<div class="code-line"><span class="lua-comment">-- Vyron Internal Utilities</span></div>
<div class="code-line"><span class="lua-keyword">local</span> <span class="lua-variable">utils</span> <span class="lua-operator">=</span> <span class="lua-bracket">{}</span></div>
<div class="code-line"></div>
<div class="code-line"><span class="lua-keyword">function</span> <span class="lua-variable">utils</span><span class="lua-operator">.</span><span class="lua-function">notify</span><span class="lua-bracket">(</span><span class="lua-variable">message</span><span class="lua-bracket">)</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-function">game</span><span class="lua-operator">:</span><span class="lua-method">GetService</span><span class="lua-bracket">(</span><span class="lua-string">"StarterGui"</span><span class="lua-bracket">)</span><span class="lua-operator">:</span><span class="lua-method">SetCore</span><span class="lua-bracket">(</span><span class="lua-string">"SendNotification"</span><span class="lua-operator">,</span> <span class="lua-bracket">{</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-property">Title</span> <span class="lua-operator">=</span> <span class="lua-string">"Vyron Internal"</span><span class="lua-operator">,</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-property">Text</span> <span class="lua-operator">=</span> <span class="lua-variable">message</span><span class="lua-operator">,</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-property">Duration</span> <span class="lua-operator">=</span> <span class="lua-number">3</span></div>
<div class="code-line">&nbsp;&nbsp;&nbsp;&nbsp;<span class="lua-bracket">})</span></div>
<div class="code-line"><span class="lua-keyword">end</span></div>
<div class="code-line"></div>
<div class="code-line"><span class="lua-keyword">return</span> <span class="lua-variable">utils</span></div>`
    };
    
    editor.innerHTML = fileContents[filename] || fileContents['main.lua'];
    updateLineNumbers();
}

function createNewFile() {
    const filename = prompt('Enter filename (e.g., script.lua):');
    if (filename && filename.endsWith('.lua')) {
        const fileList = document.querySelector('.file-list');
        const newFile = document.createElement('div');
        newFile.className = 'file-item';
        newFile.onclick = () => selectFile(newFile, filename);
        newFile.innerHTML = `
            <span class="file-icon">📄</span>
            <span class="file-name">${filename}</span>
        `;
        fileList.appendChild(newFile);
        
        // Select the new file
        selectFile(newFile, filename);
        
        // Add empty content
        const editor = document.getElementById('codeEditor');
        editor.innerHTML = '<div class="code-line"><span class="lua-comment">-- New Lua Script</span></div>';
        updateLineNumbers();
    } else if (filename) {
        alert('Please enter a valid .lua filename');
    }
}

// Editor functionality
function initializeEditor() {
    const editor = document.getElementById('codeEditor');
    
    // Handle typing
    editor.addEventListener('input', function() {
        updateLineNumbers();
        applySyntaxHighlighting();
    });
    
    // Handle Enter key for new lines
    editor.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            insertNewLine();
        }
        
        if (e.key === 'Tab') {
            e.preventDefault();
            insertTab();
        }
    });
}

function insertNewLine() {
    const editor = document.getElementById('codeEditor');
    const newLine = document.createElement('div');
    newLine.className = 'code-line';
    newLine.innerHTML = '&nbsp;';
    
    // Insert at cursor position
    const selection = window.getSelection();
    if (selection.rangeCount > 0) {
        const range = selection.getRangeAt(0);
        range.insertNode(newLine);
        
        // Move cursor to new line
        range.setStartAfter(newLine);
        range.collapse(true);
        selection.removeAllRanges();
        selection.addRange(range);
    }
    
    updateLineNumbers();
}

function insertTab() {
    const selection = window.getSelection();
    if (selection.rangeCount > 0) {
        const range = selection.getRangeAt(0);
        const tabSpan = document.createElement('span');
        tabSpan.innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;';
        range.insertNode(tabSpan);
        
        range.setStartAfter(tabSpan);
        range.collapse(true);
        selection.removeAllRanges();
        selection.addRange(range);
    }
}

function updateLineNumbers() {
    const editor = document.getElementById('codeEditor');
    const lineNumbers = document.getElementById('lineNumbers');
    const lines = editor.querySelectorAll('.code-line');
    
    lineNumbers.innerHTML = '';
    for (let i = 1; i <= Math.max(lines.length, 1); i++) {
        const lineNumber = document.createElement('div');
        lineNumber.className = 'line-number';
        lineNumber.textContent = i;
        lineNumbers.appendChild(lineNumber);
    }
}

function applySyntaxHighlighting() {
    // This would be more complex in a real implementation
    // For now, we'll keep the pre-highlighted content
}

// Action functions
function runScript() {
    const output = document.getElementById('outputContent');
    const timestamp = new Date().toLocaleTimeString();
    
    output.innerHTML += `<div class="output-line info">[${timestamp}] ▶ Running script...</div>`;
    
    setTimeout(() => {
        output.innerHTML += `<div class="output-line success">[${timestamp}] ✅ Script executed successfully</div>`;
        output.innerHTML += `<div class="output-line info">[${timestamp}] Vyron Internal Activated!</div>`;
        output.scrollTop = output.scrollHeight;
    }, 1000);
}

function saveScript() {
    const output = document.getElementById('outputContent');
    const timestamp = new Date().toLocaleTimeString();
    
    output.innerHTML += `<div class="output-line success">[${timestamp}] 💾 Script saved successfully</div>`;
    output.scrollTop = output.scrollHeight;
    
    // Show save animation
    const saveBtn = event.target;
    const originalText = saveBtn.innerHTML;
    saveBtn.innerHTML = '✅ Saved';
    saveBtn.style.background = 'rgba(80, 250, 123, 0.2)';
    
    setTimeout(() => {
        saveBtn.innerHTML = originalText;
        saveBtn.style.background = '';
    }, 2000);
}

function downloadScript() {
    const editor = document.getElementById('codeEditor');
    const content = editor.textContent || editor.innerText;
    const filename = document.querySelector('.tab span').textContent;
    
    const blob = new Blob([content], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    
    const output = document.getElementById('outputContent');
    const timestamp = new Date().toLocaleTimeString();
    output.innerHTML += `<div class="output-line success">[${timestamp}] ⬇ Downloaded ${filename}</div>`;
    output.scrollTop = output.scrollHeight;
}

function clearOutput() {
    document.getElementById('outputContent').innerHTML = '';
}