export function isValidPermissionString(permissions: Record<string, any>, permissionString: string) {
  const permissionBinary = parseInt(permissionString, 2);

  if (isNaN(permissionBinary)) return false;

  const allValidPermissions = Object.values(permissions)
    .filter(value => typeof value === 'number')
    .reduce((sum, value) => sum + (value as number), 0);

  // Check if the permission binary is a valid subset of the possible permissions
  return (permissionBinary & ~allValidPermissions) === 0;
}
