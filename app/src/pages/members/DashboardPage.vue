<template>
<div>
  Member Dashboard

 MemberUid:  {{ auth.memberUid }}
 MemberEmail:  {{ auth.memberEmail }}
</div>

</template>

<script setup language="ts">

import { useAuthStore } from '../../stores/auth';
const auth = useAuthStore();

</script>
