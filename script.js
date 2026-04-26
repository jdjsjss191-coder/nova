// Enhanced animations and interactions
document.addEventListener('DOMContentLoaded', function() {
    
    // Smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Add mouse movement parallax effect
    document.addEventListener('mousemove', (e) => {
        const mouseX = e.clientX / window.innerWidth;
        const mouseY = e.clientY / window.innerHeight;
        
        // Move waves based on mouse position
        const waves = document.querySelectorAll('.wave');
        waves.forEach((wave, index) => {
            const speed = (index + 1) * 0.5;
            const x = mouseX * speed * 10;
            const y = mouseY * speed * 10;
            wave.style.transform = `translate(${x}px, ${y}px)`;
        });

        // Move particles slightly
        const particles = document.querySelectorAll('.particle');
        particles.forEach((particle, index) => {
            const speed = (index + 1) * 0.2;
            const x = mouseX * speed * 5;
            const y = mouseY * speed * 5;
            particle.style.transform += ` translate(${x}px, ${y}px)`;
        });
    });

    // Add click ripple effect to buttons
    function createRipple(event) {
        const button = event.currentTarget;
        const circle = document.createElement('span');
        const diameter = Math.max(button.clientWidth, button.clientHeight);
        const radius = diameter / 2;

        circle.style.width = circle.style.height = `${diameter}px`;
        circle.style.left = `${event.clientX - button.offsetLeft - radius}px`;
        circle.style.top = `${event.clientY - button.offsetTop - radius}px`;
        circle.classList.add('ripple');

        const ripple = button.getElementsByClassName('ripple')[0];
        if (ripple) {
            ripple.remove();
        }

        button.appendChild(circle);
    }

    // Add ripple effect styles
    const style = document.createElement('style');
    style.textContent = `
        .ripple {
            position: absolute;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.3);
            transform: scale(0);
            animation: ripple-animation 0.6s linear;
            pointer-events: none;
        }

        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);

    // Apply ripple effect to buttons
    document.querySelectorAll('.btn-primary, .btn-secondary').forEach(button => {
        button.addEventListener('click', createRipple);
    });

    // Add scroll-based animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe elements for scroll animations
    document.querySelectorAll('.hero-content > *').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Add typing effect to the title
    function typeWriter(element, text, speed = 100) {
        let i = 0;
        element.innerHTML = '';
        
        function type() {
            if (i < text.length) {
                element.innerHTML += text.charAt(i);
                i++;
                setTimeout(type, speed);
            }
        }
        type();
    }

    // Enhanced particle system
    function createAdvancedParticles() {
        const particleContainer = document.querySelector('.floating-particles');
        
        // Create more dynamic particles
        for (let i = 0; i < 15; i++) {
            const particle = document.createElement('div');
            particle.className = 'advanced-particle';
            
            // Random properties
            const size = Math.random() * 6 + 2;
            const hue = Math.random() * 360;
            const duration = Math.random() * 20 + 10;
            const delay = Math.random() * 10;
            
            particle.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                background: hsl(${hue}, 70%, 60%);
                border-radius: 50%;
                left: ${Math.random() * 100}%;
                animation: advancedFloat ${duration}s infinite linear;
                animation-delay: -${delay}s;
                box-shadow: 0 0 ${size * 2}px hsl(${hue}, 70%, 60%);
                opacity: 0.7;
            `;
            
            particleContainer.appendChild(particle);
        }
    }

    // Add advanced particle animation
    const advancedParticleStyle = document.createElement('style');
    advancedParticleStyle.textContent = `
        @keyframes advancedFloat {
            0% {
                transform: translateY(100vh) translateX(0) rotate(0deg) scale(0);
                opacity: 0;
            }
            10% {
                opacity: 0.7;
                transform: translateY(90vh) translateX(10px) rotate(36deg) scale(1);
            }
            50% {
                transform: translateY(50vh) translateX(-20px) rotate(180deg) scale(1.2);
            }
            90% {
                opacity: 0.7;
                transform: translateY(10vh) translateX(15px) rotate(324deg) scale(0.8);
            }
            100% {
                transform: translateY(-10vh) translateX(0) rotate(360deg) scale(0);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(advancedParticleStyle);

    // Initialize advanced particles
    createAdvancedParticles();

    // Add navbar scroll effect
    let lastScrollTop = 0;
    const navbar = document.querySelector('.navbar');
    
    window.addEventListener('scroll', () => {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        if (scrollTop > lastScrollTop && scrollTop > 100) {
            // Scrolling down
            navbar.style.transform = 'translateY(-100%)';
        } else {
            // Scrolling up
            navbar.style.transform = 'translateY(0)';
        }
        
        lastScrollTop = scrollTop;
    });

    // Add smooth transitions to navbar
    navbar.style.transition = 'transform 0.3s ease-in-out';

    console.log('🚀 Vyron Internal website loaded with enhanced animations!');
});

// Add some interactive elements
document.addEventListener('click', (e) => {
    // Create click sparkles
    if (e.target.closest('.hero-section')) {
        createSparkle(e.clientX, e.clientY);
    }
});

function createSparkle(x, y) {
    const sparkle = document.createElement('div');
    sparkle.style.cssText = `
        position: fixed;
        left: ${x}px;
        top: ${y}px;
        width: 10px;
        height: 10px;
        background: radial-gradient(circle, #fff, transparent);
        border-radius: 50%;
        pointer-events: none;
        z-index: 1000;
        animation: sparkleAnimation 0.6s ease-out forwards;
    `;
    
    document.body.appendChild(sparkle);
    
    setTimeout(() => {
        sparkle.remove();
    }, 600);
}

// Add sparkle animation
const sparkleStyle = document.createElement('style');
sparkleStyle.textContent = `
    @keyframes sparkleAnimation {
        0% {
            transform: scale(0) rotate(0deg);
            opacity: 1;
        }
        50% {
            transform: scale(1) rotate(180deg);
            opacity: 0.8;
        }
        100% {
            transform: scale(0) rotate(360deg);
            opacity: 0;
        }
    }
`;
document.head.appendChild(sparkleStyle);
// Enhanced Visual Effects
document.addEventListener('DOMContentLoaded', function() {
    
    // Create dynamic color shifting for the entire page
    function createColorShift() {
        const root = document.documentElement;
        let hue = 0;
        
        setInterval(() => {
            hue = (hue + 0.5) % 360;
            root.style.setProperty('--dynamic-hue', hue);
        }, 100);
    }
    
    // Add CSS custom property for dynamic colors
    const dynamicStyle = document.createElement('style');
    dynamicStyle.textContent = `
        :root {
            --dynamic-hue: 0;
        }
        
        .dynamic-glow {
            filter: hue-rotate(var(--dynamic-hue)deg);
        }
    `;
    document.head.appendChild(dynamicStyle);
    
    // Initialize color shifting
    createColorShift();
    
    // Enhanced particle system with mouse interaction
    function createInteractiveParticles() {
        const container = document.querySelector('.floating-particles');
        let mouseX = 0;
        let mouseY = 0;
        
        document.addEventListener('mousemove', (e) => {
            mouseX = e.clientX / window.innerWidth;
            mouseY = e.clientY / window.innerHeight;
        });
        
        // Create magnetic particles that follow mouse
        for (let i = 0; i < 8; i++) {
            const particle = document.createElement('div');
            particle.className = 'magnetic-particle';
            
            const size = Math.random() * 8 + 4;
            const hue = Math.random() * 360;
            
            particle.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                background: radial-gradient(circle, 
                    hsl(${hue}, 80%, 70%) 0%, 
                    hsl(${hue + 60}, 70%, 60%) 50%, 
                    transparent 100%);
                border-radius: 50%;
                pointer-events: none;
                z-index: 10;
                box-shadow: 
                    0 0 ${size * 2}px hsl(${hue}, 80%, 70%),
                    0 0 ${size * 4}px hsl(${hue + 60}, 70%, 60%);
                transition: all 0.3s ease-out;
            `;
            
            container.appendChild(particle);
            
            // Animate particles to follow mouse with delay
            function updateParticle() {
                const delay = (i + 1) * 0.1;
                const targetX = mouseX * window.innerWidth + Math.sin(Date.now() * 0.001 + i) * 50;
                const targetY = mouseY * window.innerHeight + Math.cos(Date.now() * 0.001 + i) * 50;
                
                particle.style.left = targetX + 'px';
                particle.style.top = targetY + 'px';
                
                requestAnimationFrame(updateParticle);
            }
            
            setTimeout(updateParticle, i * 100);
        }
    }
    
    // Initialize interactive particles
    createInteractiveParticles();
    
    // Add scroll-based parallax for background elements
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const parallax = scrolled * 0.5;
        
        document.querySelectorAll('.wave').forEach((wave, index) => {
            const speed = (index + 1) * 0.3;
            wave.style.transform += ` translateY(${parallax * speed}px)`;
        });
    });
    
    // Enhanced button interactions
    document.querySelectorAll('.btn-primary, .btn-secondary').forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px) scale(1.08)';
            this.style.filter = 'brightness(1.2) saturate(1.3)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
            this.style.filter = 'brightness(1) saturate(1)';
        });
    });
    
    // Enhanced fade-in animation instead of text reveal
    function enhancedFadeIn() {
        const title = document.querySelector('.hero-title');
        title.style.opacity = '0';
        title.style.transform = 'translateY(30px)';
        
        setTimeout(() => {
            title.style.transition = 'all 1s ease-out';
            title.style.opacity = '1';
            title.style.transform = 'translateY(0)';
        }, 500);
    }
    
    // Initialize enhanced fade-in
    enhancedFadeIn();
    
    // Add dynamic lighting effect
    function createLightingEffect() {
        const lighting = document.createElement('div');
        lighting.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 5;
            background: radial-gradient(circle 300px at var(--mouse-x, 50%) var(--mouse-y, 50%), 
                rgba(138, 43, 226, 0.1) 0%, 
                rgba(30, 144, 255, 0.05) 30%, 
                transparent 70%);
            mix-blend-mode: screen;
            transition: all 0.3s ease;
        `;
        
        document.body.appendChild(lighting);
        
        document.addEventListener('mousemove', (e) => {
            const x = (e.clientX / window.innerWidth) * 100;
            const y = (e.clientY / window.innerHeight) * 100;
            lighting.style.setProperty('--mouse-x', x + '%');
            lighting.style.setProperty('--mouse-y', y + '%');
        });
    }
    
    // Initialize lighting effect
    createLightingEffect();
});

// Add performance-optimized animations
function optimizeAnimations() {
    // Use requestAnimationFrame for smooth animations
    let ticking = false;
    
    function updateAnimations() {
        // Update any continuous animations here
        ticking = false;
    }
    
    function requestTick() {
        if (!ticking) {
            requestAnimationFrame(updateAnimations);
            ticking = true;
        }
    }
    
    // Throttle expensive operations
    window.addEventListener('scroll', requestTick);
    window.addEventListener('resize', requestTick);
}

// Initialize optimizations
optimizeAnimations();
// Enhanced Planet System with Mouse Interaction
document.addEventListener('DOMContentLoaded', function() {
    
    // Add mouse interaction to planets
    function addPlanetInteraction() {
        const planets = document.querySelectorAll('.planet');
        
        document.addEventListener('mousemove', (e) => {
            const mouseX = e.clientX / window.innerWidth;
            const mouseY = e.clientY / window.innerHeight;
            
            planets.forEach((planet, index) => {
                const speed = (index + 1) * 0.3;
                const x = (mouseX - 0.5) * speed * 20;
                const y = (mouseY - 0.5) * speed * 20;
                
                planet.style.transform += ` translate(${x}px, ${y}px)`;
            });
        });
        
        // Add hover effects to planets
        planets.forEach(planet => {
            planet.addEventListener('mouseenter', function() {
                this.style.filter = 'brightness(1.3) saturate(1.2)';
                this.style.transform += ' scale(1.1)';
                this.style.transition = 'all 0.3s ease';
            });
            
            planet.addEventListener('mouseleave', function() {
                this.style.filter = 'brightness(1) saturate(1)';
                this.style.transform = this.style.transform.replace(' scale(1.1)', '');
            });
        });
    }
    
    // Initialize planet interactions
    addPlanetInteraction();
    
    // Add random twinkling stars
    function createStarField() {
        const starContainer = document.querySelector('.planets-container');
        
        for (let i = 0; i < 50; i++) {
            const star = document.createElement('div');
            star.className = 'star';
            
            const size = Math.random() * 3 + 1;
            const x = Math.random() * 100;
            const y = Math.random() * 100;
            const delay = Math.random() * 5;
            
            star.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                background: radial-gradient(circle, #ffffff 0%, transparent 70%);
                border-radius: 50%;
                left: ${x}%;
                top: ${y}%;
                animation: twinkle 3s ease-in-out infinite;
                animation-delay: ${delay}s;
                box-shadow: 0 0 ${size * 2}px rgba(255, 255, 255, 0.5);
            `;
            
            starContainer.appendChild(star);
        }
    }
    
    // Add twinkling animation for stars
    const starStyle = document.createElement('style');
    starStyle.textContent = `
        @keyframes twinkle {
            0%, 100% {
                opacity: 0.3;
                transform: scale(1);
            }
            50% {
                opacity: 1;
                transform: scale(1.2);
            }
        }
    `;
    document.head.appendChild(starStyle);
    
    // Initialize star field
    createStarField();
    
    // Add planet collision detection for fun effects
    function addPlanetEffects() {
        const planets = document.querySelectorAll('.planet');
        
        planets.forEach(planet => {
            planet.addEventListener('click', function() {
                // Create explosion effect
                const explosion = document.createElement('div');
                explosion.style.cssText = `
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    width: 0;
                    height: 0;
                    background: radial-gradient(circle, 
                        rgba(255, 255, 255, 0.8) 0%, 
                        rgba(138, 43, 226, 0.6) 30%, 
                        rgba(30, 144, 255, 0.4) 60%, 
                        transparent 100%);
                    border-radius: 50%;
                    transform: translate(-50%, -50%);
                    animation: explode 0.6s ease-out forwards;
                    pointer-events: none;
                    z-index: 10;
                `;
                
                this.appendChild(explosion);
                
                setTimeout(() => {
                    explosion.remove();
                }, 600);
            });
        });
    }
    
    // Add explosion animation
    const explosionStyle = document.createElement('style');
    explosionStyle.textContent = `
        @keyframes explode {
            0% {
                width: 0;
                height: 0;
                opacity: 1;
            }
            50% {
                width: 200px;
                height: 200px;
                opacity: 0.8;
            }
            100% {
                width: 300px;
                height: 300px;
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(explosionStyle);
    
    // Initialize planet effects
    addPlanetEffects();
});

// Add dynamic planet generation
function addRandomPlanet() {
    const container = document.querySelector('.planets-container');
    const planet = document.createElement('div');
    planet.className = 'planet dynamic-planet';
    
    const size = Math.random() * 60 + 40;
    const x = Math.random() * 80 + 10;
    const y = Math.random() * 80 + 10;
    const hue = Math.random() * 360;
    const duration = Math.random() * 60 + 40;
    
    planet.innerHTML = '<div class="planet-surface"></div>';
    
    planet.style.cssText = `
        width: ${size}px;
        height: ${size}px;
        left: ${x}%;
        top: ${y}%;
        animation: planetOrbit ${duration}s linear infinite;
    `;
    
    const surface = planet.querySelector('.planet-surface');
    surface.style.cssText = `
        background: radial-gradient(circle at 30% 30%, 
            hsl(${hue}, 70%, 60%) 0%, 
            hsl(${hue + 60}, 60%, 50%) 40%, 
            hsl(${hue + 120}, 50%, 40%) 100%);
        box-shadow: 
            inset -${size * 0.2}px -${size * 0.2}px ${size * 0.4}px rgba(0, 0, 0, 0.5),
            inset ${size * 0.1}px ${size * 0.1}px ${size * 0.2}px hsla(${hue}, 70%, 60%, 0.3),
            0 0 ${size * 0.5}px hsla(${hue}, 70%, 60%, 0.2);
        animation: planetRotate ${Math.random() * 20 + 10}s linear infinite;
    `;
    
    container.appendChild(planet);
    
    // Remove planet after some time to prevent overcrowding
    setTimeout(() => {
        planet.remove();
    }, duration * 1000);
}

// Occasionally add new planets
setInterval(addRandomPlanet, 30000); // Every 30 seconds
// Login Modal Functions
function openLoginModal() {
    document.getElementById('loginModal').style.display = 'block';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

function closeLoginModal() {
    document.getElementById('loginModal').style.display = 'none';
    document.body.style.overflow = 'auto'; // Restore scrolling
}

// Close modal when clicking outside of it
window.onclick = function(event) {
    const modal = document.getElementById('loginModal');
    if (event.target == modal) {
        closeLoginModal();
    }
}

// Handle login form submission
document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const scriptKey = document.getElementById('scriptKey').value;
    
    // Add loading state
    const submitBtn = this.querySelector('.login-btn');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<span>VERIFYING...</span>';
    submitBtn.disabled = true;
    
    // Simulate authentication
    setTimeout(() => {
        // Basic validation (you can make this more sophisticated)
        if (username.length >= 3 && password.length >= 6 && scriptKey.length >= 10) {
            // Store login state
            sessionStorage.setItem('vyron_logged_in', 'true');
            sessionStorage.setItem('vyron_username', username);
            sessionStorage.setItem('vyron_script_key', scriptKey);
            
            // Success - redirect to editor
            showLoginSuccess();
            setTimeout(() => {
                window.location.href = 'editor.html';
            }, 1500);
        } else {
            // Error - show error message
            showLoginError();
            
            // Restore button
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        }
    }, 2000);
});

function showLoginSuccess() {
    const form = document.getElementById('loginForm');
    form.innerHTML = `
        <div style="text-align: center; padding: 40px 20px;">
            <div style="font-size: 3rem; color: #50fa7b; margin-bottom: 20px;">✅</div>
            <h3 style="color: #50fa7b; margin-bottom: 10px;">Access Granted!</h3>
            <p style="color: #b0b0b0;">Redirecting to Vyron Internal Editor...</p>
            <div class="loading-bar" style="width: 100%; height: 4px; background: rgba(80, 250, 123, 0.2); border-radius: 2px; margin-top: 20px; overflow: hidden;">
                <div style="width: 100%; height: 100%; background: #50fa7b; animation: loadingProgress 1.5s ease-out;"></div>
            </div>
        </div>
    `;
}

function showLoginError() {
    // Create error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'login-error';
    errorDiv.innerHTML = `
        <div style="background: rgba(255, 85, 85, 0.1); border: 1px solid rgba(255, 85, 85, 0.3); border-radius: 10px; padding: 15px; margin-bottom: 20px; text-align: center;">
            <div style="color: #ff5555; font-size: 1.2rem; margin-bottom: 5px;">❌</div>
            <div style="color: #ff5555; font-weight: 600;">Error: Invalid Details</div>
            <div style="color: #ffb86c; font-size: 0.9rem; margin-top: 5px;">Please check your username, password, and script key</div>
        </div>
    `;
    
    // Insert error before form
    const form = document.getElementById('loginForm');
    form.parentNode.insertBefore(errorDiv, form);
    
    // Remove error after 5 seconds
    setTimeout(() => {
        errorDiv.remove();
    }, 5000);
    
    // Shake animation for form
    form.style.animation = 'shake 0.5s ease-in-out';
    setTimeout(() => {
        form.style.animation = '';
    }, 500);
}

// Add enter key support for modal
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeLoginModal();
    }
});
