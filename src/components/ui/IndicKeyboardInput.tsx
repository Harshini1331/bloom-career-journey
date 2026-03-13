import { useRef, useEffect } from 'react';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';

interface IndicKeyboardInputProps extends React.ComponentPropsWithoutRef<'input' | 'textarea'> {
  as?: 'input' | 'textarea';
  onIndicInput?: (value: string) => void;
}

// Global registry for inputs that need keyboard support
const inputRegistry = new Map<HTMLInputElement | HTMLTextAreaElement, (value: string) => void>();

export function registerIndicInput(
  element: HTMLInputElement | HTMLTextAreaElement,
  handler: (value: string) => void
) {
  inputRegistry.set(element, handler);
}

export function unregisterIndicInput(element: HTMLInputElement | HTMLTextAreaElement) {
  inputRegistry.delete(element);
}

export function updateIndicInput(
  element: HTMLInputElement | HTMLTextAreaElement,
  newValue: string
) {
  const handler = inputRegistry.get(element);
  if (handler) {
    handler(newValue);
  }
}

export function IndicKeyboardInput({ as = 'input', onIndicInput, ...props }: IndicKeyboardInputProps) {
  const inputRef = useRef<HTMLInputElement | HTMLTextAreaElement>(null);

  useEffect(() => {
    const element = inputRef.current;
    if (!element || !onIndicInput) return;

    registerIndicInput(element, onIndicInput);
    return () => {
      unregisterIndicInput(element);
    };
  }, [onIndicInput]);
  
  const Component = as === 'textarea' ? Textarea : Input;
  return <Component ref={inputRef as any} {...props} />;
}

