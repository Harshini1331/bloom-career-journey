// Google Drive link helpers
// Provide a fileId string (the 33+ char id in a share link)

export const buildDrivePreviewUrl = (fileId: string): string => {
  // Opens Google Drive preview viewer
  return `https://drive.google.com/file/d/${fileId}/preview`;
};

export const buildDriveViewUrl = (fileId: string): string => {
  // Opens the file in Drive (details page)
  return `https://drive.google.com/file/d/${fileId}/view?usp=sharing`;
};

export const buildDriveDownloadUrl = (fileId: string): string => {
  // Forces a direct download for supported files
  return `https://drive.google.com/uc?export=download&id=${fileId}`;
};

export type ResourceLink = {
  id: string;
  label: string;
  fileId?: string; // Google Drive file id
  externalUrl?: string; // Direct URL for non-Drive resources
};


