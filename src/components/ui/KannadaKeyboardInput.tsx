import { useRef, useEffect } from 'react';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';

interface KannadaKeyboardInputProps extends React.ComponentPropsWithoutRef<'input' | 'textarea'> {
  as?: 'input' | 'textarea';
  onKannadaInput?: (value: string) => void;
}

// Global registry for inputs that need keyboard support
const inputRegistry = new Map<HTMLInputElement | HTMLTextAreaElement, (value: string) => void>();

export function registerKannadaInput(
  element: HTMLInputElement | HTMLTextAreaElement,
  handler: (value: string) => void
) {
  inputRegistry.set(element, handler);
}

export function unregisterKannadaInput(element: HTMLInputElement | HTMLTextAreaElement) {
  inputRegistry.delete(element);
}

export function updateKannadaInput(
  element: HTMLInputElement | HTMLTextAreaElement,
  newValue: string
) {
  const handler = inputRegistry.get(element);
  if (handler) {
    handler(newValue);
  }
}

export function KannadaKeyboardInput({ as = 'input', onKannadaInput, ...props }: KannadaKeyboardInputProps) {
  const inputRef = useRef<HTMLInputElement | HTMLTextAreaElement>(null);
  
  useEffect(() => {
    const element = inputRef.current;
    if (!element || !onKannadaInput) return;
    
    registerKannadaInput(element, onKannadaInput);
    return () => {
      unregisterKannadaInput(element);
    };
  }, [onKannadaInput]);
  
  const Component = as === 'textarea' ? Textarea : Input;
  return <Component ref={inputRef as any} {...props} />;
}

