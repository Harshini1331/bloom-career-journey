import { createRoot } from 'react-dom/client'
import App from './App.tsx'
import './index.css'

console.log('main.tsx starting...');

// Check if root element exists
const rootElement = document.getElementById("root");
console.log('Root element found:', !!rootElement);

if (!rootElement) {
  console.error('Root element not found! This will cause a blank screen.');
  throw new Error('Root element not found');
}

try {
  const root = createRoot(rootElement);
  console.log('React root created successfully');
  
  root.render(<App />);
  console.log('App component rendered');
} catch (error) {
  console.error('Error rendering app:', error);
}
