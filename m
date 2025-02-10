Return-Path: <kvm-ppc+bounces-219-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F0CA2E2B9
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Feb 2025 04:25:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EE3118878E8
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Feb 2025 03:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D9950276;
	Mon, 10 Feb 2025 03:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9UndsGS"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B235957
	for <kvm-ppc@vger.kernel.org>; Mon, 10 Feb 2025 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739157921; cv=none; b=H8uGjp5dmCi5KOIOT5w317aE/nc0aePgC11MyobCh0ftjtfEhvEOqZ3pO3ftDuS7G1xZYhQYpMTh/GNjhJzGrC1Xb+9iEjHwAJUUiIyLyo3FCvPPmZYAEI0JOa2Qhr0b1Hzwf4Rk+rYAvmlzYKy6fd317WPu9JKtrTKo4gQD3+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739157921; c=relaxed/simple;
	bh=ENk2/M5ydunT4iDO9qzxMPXgdC+do66POkM/g2i2QYc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=jTjanlKsb8HK7f6jIRVDqFq94IYI6mpQLC3t7oL6+m5f7ZkFIqDrfVPArgaE3x6q4F3O7U+tCaKZJhreN6OASUuY55l7sgCzrtAy72Z8737VfPlcDiD7bKcYSoON2VGc3Mgqm0+FYGiCHfEuhTqCMXM2WGcS0GF6Zgj9jkoLheI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9UndsGS; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f9f5caa37cso6767146a91.0
        for <kvm-ppc@vger.kernel.org>; Sun, 09 Feb 2025 19:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739157919; x=1739762719; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLFLdcuwd5lZWnP7lXmBlVP8S8d171hS/PDd6lMK4/A=;
        b=f9UndsGSpZgJpc7U4Oqjegq74MXVaI4dfEwV6yJ2vQXWwJ1bPQzBqnDS5J3iB516JK
         R6UjQoCek38J4J9bRKm369W+jKULoCq4pqj5H64+qGtuuX9W/hMADtr2GHTjsFYmClZG
         fEm62n7iwljE9AkOHnOZwsUd1Y26pFX5QDTtPgc1QhXkCkDX7+cdBFK3QUayuP6z2b95
         T64WBYS76gxg5yMc2fUhnhTivaGSVXJ4RaAy2fdicJsvHQA3/rbuwb1ONfoC+uOGdhRP
         NkRPlsnWXrlkuSyAmUygZeg2m7xVJA2kSnCxwzLGENd6nL9mzMmk0IJB4TzsClLh+NB0
         JgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739157919; x=1739762719;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kLFLdcuwd5lZWnP7lXmBlVP8S8d171hS/PDd6lMK4/A=;
        b=Nc6Oxbj6bz9ep3pN9cjNuu4voNkaSujQRIzQkkV1hZD8ubU5dKYoUC1O0Bj3TydYgd
         mVz0OVWEzGuUQDbIds70qfMQ0cYWDNgdZeU+ZdV/+3Gt4h9bPZj6L1Gmr2v25rN82zPl
         zW5MIckHrlJvf5b7bpnrTb6I9xoly030gl2AU96ifVltYMPoqoak0StD7yBN2/m4wqvK
         vzuxIf6oznrJjxJ5yEh3QqSYNVmoCGCqV+6DYy/DrXxLedvmc5fLuXmCX24DYdbTCbO0
         DoW+7Qevl9KiVeUl+PVC+6t2c7r0iecCymLggPoMFnI+k39ATxrkajqkgejESSc3UGy4
         RZzA==
X-Forwarded-Encrypted: i=1; AJvYcCVWIz/wYpqri+Am5BVoPFLLZGOG/DnD7BrIuQHOKS0/AP2Z+qqnlExCZ8RTje2vQMgQSo737OYu@vger.kernel.org
X-Gm-Message-State: AOJu0YzkNjr45ox3dkJQQr3Tb7YV6sINSEXt12PaT+vz3hmseVyrF56k
	Nq9On5QrRkSmcCX3qIlYOBthcKF1uNheFUxhXkIMViSkqaqCjUCr4VaooA==
X-Gm-Gg: ASbGncstG8JK78WqxXaTHKf6xvlz/JIeZhvmFNYaf6w1ziDbxgrrmQ/VzJM8o2oM8aC
	/1mATVsqIoOCnCHZ31+Tx/BnCxLzE29OnNNkZOZzDCd2VBLjpXGCGRiYghyjGJh6+ckT9PNpfTi
	K7rr2houkgavgoui06LOCzQQl+wgw7nimTnwIESxOn0rY58XowmvTJwrQXtq1t7tHR+3MxWbiu+
	LwWxQE29s9kCtv1j0W+oWK6ZkwwGZP9GNJMdccw9o4ZL7DyBsZ55eNGMSD42TkMvBVlEsLBAR9q
	Ke7Qx5UIBxE=
X-Google-Smtp-Source: AGHT+IHuc0Oyd0s6G3iS9y4+Se9tFkgDD6Mc2WEHoKTAeyMlKk9pVIEVOL6fnpnz3eNbAhWJHeiscA==
X-Received: by 2002:a17:90b:1905:b0:2fa:1e56:5d82 with SMTP id 98e67ed59e1d1-2fa2489865cmr18557423a91.17.1739157918813;
        Sun, 09 Feb 2025 19:25:18 -0800 (PST)
Received: from localhost ([118.209.251.215])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa099f4dadsm7329226a91.10.2025.02.09.19.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2025 19:25:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 10 Feb 2025 13:25:12 +1000
Message-Id: <D7OG0Z86JLDP.3JUMXAPUOD7GC@gmail.com>
Cc: <harshpb@linux.ibm.com>, <shivaprasadbhat@gmail.com>
Subject: Re: [PATCH v3] spapr: nested: Add support for reporting Hostwide
 state counter
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Vaibhav Jain" <vaibhav@linux.ibm.com>, <qemu-devel@nongnu.org>,
 <kvm-ppc@vger.kernel.org>, <qemu-ppc@nongnu.org>
X-Mailer: aerc 0.19.0
References: <20250203100912.82560-1-vaibhav@linux.ibm.com>
In-Reply-To: <20250203100912.82560-1-vaibhav@linux.ibm.com>

On Mon Feb 3, 2025 at 8:09 PM AEST, Vaibhav Jain wrote:
> Add support for reporting Hostwide state counters for nested KVM pseries

I'd add a brief first paragraph that just describe the concept of
"hostwide state counters" without going into any spec.

  Hostwide state counters are statistics about the L0 hypervisor's
  part in the operation of L2 guests, which are accessible by the
  L1 via hcalls to the L0. These statistics don't necessarily apply
  to any particular L2, and can be relevant even when there are no
  L2 guests in the system at all.

Something like that?

> guests running with 'cap-nested-papr' on Qemu-TCG acting as
> L0-hypervisor. sPAPR supports reporting various stats counters for
> Guest-Management-Area(GMA) thats owned by L0-Hypervisor and are documente=
d
> at [1]. These stats counters are exposed via a new bit-flag named
> 'getHostWideState' for the H_GUEST_GET_STATE hcall. Once this flag is set
> the hcall should populate the Guest-State-Elements in the requested GSB
> with the stat counter values. Currently following five counters are
> supported:
>
> * host_heap		: The currently used bytes in the
> 			  Hypervisor's Guest Management Space
> 			  associated with the Host Partition.
> * host_heap_max		: The maximum bytes available in the
> 			  Hypervisor's Guest Management Space
> 			  associated with the Host Partition.
> * host_pagetable	: The currently used bytes in the
> 			  Hypervisor's Guest Page Table Management
> 			  Space associated with the Host Partition.
> * host_pagetable_max	: The maximum bytes available in the
> 			  Hypervisor's Guest Page Table Management
> 			  Space associated with the Host Partition.
> * host_pagetable_reclaim: The amount of space in bytes that has
> 			  been reclaimed due to overcommit in the
> 			  Hypervisor's Guest Page Table Management
> 			  Space associated with the Host Partition.

Rather than list these out in the changelog, could they go into a
doc or at least code comment?

> At the moment '0' is being reported for all these counters as these
> counters doesnt align with how L0-Qemu manages Guest memory.
>
> The patch implements support for these counters by adding new members to
> the 'struct SpaprMachineStateNested'. These new members are then plugged
> into the existing 'guest_state_element_types[]' with the help of a new
> macro 'GSBE_NESTED_MACHINE_DW' together with a new helper
> 'get_machine_ptr()'. guest_state_request_check() is updated to ensure
> correctness of the requested GSB and finally h_guest_getset_state() is
> updated to handle the newly introduced flag
> 'GUEST_STATE_REQUEST_HOST_WIDE'.
>
> This patch is tested with the proposed linux-kernel implementation to
> expose these stat-counter as perf-events at [2].
>
> [1]
> https://lore.kernel.org/all/20241222140247.174998-2-vaibhav@linux.ibm.com
>
> [2]
> https://lore.kernel.org/all/20241222140247.174998-1-vaibhav@linux.ibm.com
>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
> ---
> Changelog:
>
> v2->v1:
> * Fixed minor nits suggested [Harsh]
> * s/GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE/GUEST_STATE_REQUEST_HOST_WIDE=
/
> in guest_state_request_check() [Harsh]
> * MInor change in the order of comparision in h_guest_getset_state()
> [Harsh]
> * Added reviewed-by of Harsh
>
> v1->v2:
> * Introduced new flags to correctly compare hcall flags
>   for H_GUEST_{GET,SET}_STATE [Harsh]
> * Fixed ordering of new GSB elements in spapr_nested.h [Harsh]
> * s/GSBE_MACHINE_NESTED_DW/GSBE_NESTED_MACHINE_DW/
> * Minor tweaks to patch description
> * Updated recipients list
> ---
>  hw/ppc/spapr_nested.c         | 82 ++++++++++++++++++++++++++---------
>  include/hw/ppc/spapr_nested.h | 39 ++++++++++++++---
>  2 files changed, 96 insertions(+), 25 deletions(-)
>
> diff --git a/hw/ppc/spapr_nested.c b/hw/ppc/spapr_nested.c
> index 7def8eb73b..d1aa6fc866 100644
> --- a/hw/ppc/spapr_nested.c
> +++ b/hw/ppc/spapr_nested.c
> @@ -64,10 +64,9 @@ static
>  SpaprMachineStateNestedGuest *spapr_get_nested_guest(SpaprMachineState *=
spapr,
>                                                       target_ulong guesti=
d)
>  {
> -    SpaprMachineStateNestedGuest *guest;
> -
> -    guest =3D g_hash_table_lookup(spapr->nested.guests, GINT_TO_POINTER(=
guestid));
> -    return guest;
> +    return spapr->nested.guests ?
> +        g_hash_table_lookup(spapr->nested.guests,
> +                            GINT_TO_POINTER(guestid)) : NULL;
>  }

Is this a bug-fix that should go in first? What if L1 makes hcall with
no L2 created today?

> =20
>  bool spapr_get_pate_nested_papr(SpaprMachineState *spapr, PowerPCCPU *cp=
u,
> @@ -613,6 +612,13 @@ static void *get_guest_ptr(SpaprMachineStateNestedGu=
est *guest,
>      return guest; /* for GSBE_NESTED */
>  }
> =20
> +static void *get_machine_ptr(SpaprMachineStateNestedGuest *guest,
> +                             target_ulong vcpuid)
> +{
> +    SpaprMachineState *spapr =3D SPAPR_MACHINE(qdev_get_machine());
> +    return &spapr->nested;
> +}

It would be nicer if the .location op could instead be changed to take
SpaprMachineState * pointer as well, instead of using
qdev_get_machine(). guest could be NULL if none exists.

> +
>  /*
>   * set=3D1 means the L1 is trying to set some state
>   * set=3D0 means the L1 is trying to get some state
> @@ -1012,7 +1018,12 @@ struct guest_state_element_type guest_state_elemen=
t_types[] =3D {
>      GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUFFER, 0x10, runbufout,   copy_state_=
runbuf),
>      GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUF_MIN_SZ, 0x8, runbufout, out_buf_mi=
n_size),
>      GSBE_NESTED_VCPU(GSB_VCPU_HDEC_EXPIRY_TB, 0x8, hdecr_expiry_tb,
> -                     copy_state_hdecr)
> +                     copy_state_hdecr),
> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_HEAP, current_guest_heap),
> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_HEAP_MAX, max_guest_heap),
> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_SIZE, current_pgtable_size)=
,
> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_SIZE_MAX, max_pgtable_size)=
,
> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_RECLAIM, pgtable_reclaim_si=
ze),
>  };
> =20
>  void spapr_nested_gsb_init(void)
> @@ -1030,8 +1041,12 @@ void spapr_nested_gsb_init(void)
>          else if (type->id >=3D GSB_VCPU_IN_BUFFER)
>              /* 0x0c00 - 0xf000 Thread + RW */
>              type->flags =3D 0;
> +        else if (type->id >=3D GSB_GUEST_HEAP)
> +            /*0x0800 - 0x0804 Hostwide Counters + RO */

                 ^ put a space there

> +            type->flags =3D GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE |
> +                          GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY;
>          else if (type->id >=3D GSB_VCPU_LPVR)
> -            /* 0x0003 - 0x0bff Guest + RW */
> +            /* 0x0003 - 0x07ff Guest + RW */
>              type->flags =3D GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE;
>          else if (type->id >=3D GSB_HV_VCPU_STATE_SIZE)
>              /* 0x0001 - 0x0002 Guest + RO */
> @@ -1138,18 +1153,26 @@ static bool guest_state_request_check(struct gues=
t_state_request *gsr)
>              return false;
>          }
> =20
> -        if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE) {
> +        if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE) {
> +            /* Hostwide elements cant be clubbed with other types */
> +            if (!(gsr->flags & GUEST_STATE_REQUEST_HOST_WIDE)) {
> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a host=
 wide "
> +                              "Element ID:%04x.\n", id);
> +                return false;
> +            }
> +        } else  if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WI=
DE) {
>              /* guest wide element type */
>              if (!(gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE)) {
> -                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a guest wi=
de "
> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a gues=
t wide "
>                                "Element ID:%04x.\n", id);
>                  return false;
>              }
>          } else {
>              /* thread wide element type */
> -            if (gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE) {
> -                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a thread w=
ide "
> -                              "Element ID:%04x.\n", id);
> +            if (gsr->flags & (GUEST_STATE_REQUEST_GUEST_WIDE |
> +                              GUEST_STATE_REQUEST_HOST_WIDE)) {
> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a thre=
ad wide"
> +                            " Element ID:%04x.\n", id);
>                  return false;
>              }
>          }
> @@ -1509,25 +1532,44 @@ static target_ulong h_guest_getset_state(PowerPCC=
PU *cpu,
>      target_ulong buf =3D args[3];
>      target_ulong buflen =3D args[4];
>      struct guest_state_request gsr;
> -    SpaprMachineStateNestedGuest *guest;
> +    SpaprMachineStateNestedGuest *guest =3D NULL;
> =20
> -    guest =3D spapr_get_nested_guest(spapr, lpid);
> -    if (!guest) {
> -        return H_P2;
> -    }
>      gsr.buf =3D buf;
>      assert(buflen <=3D GSB_MAX_BUF_SIZE);
>      gsr.len =3D buflen;
>      gsr.flags =3D 0;
> -    if (flags & H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
> +
> +    /* Works for both get/set state */
> +    if ((flags & H_GUEST_GET_STATE_FLAGS_GUEST_WIDE) ||
> +        (flags & H_GUEST_SET_STATE_FLAGS_GUEST_WIDE)) {
>          gsr.flags |=3D GUEST_STATE_REQUEST_GUEST_WIDE;
>      }
> -    if (flags & ~H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
> -        return H_PARAMETER; /* flag not supported yet */
> -    }
> =20
>      if (set) {
> +        if (flags & ~H_GUEST_SET_STATE_FLAGS_MASK) {
> +            return H_PARAMETER;
> +        }
>          gsr.flags |=3D GUEST_STATE_REQUEST_SET;
> +    } else {
> +        /*
> +         * No reserved fields to be set in flags nor both
> +         * GUEST/HOST wide bits
> +         */
> +        if ((flags & ~H_GUEST_GET_STATE_FLAGS_MASK) ||
> +            (flags =3D=3D H_GUEST_GET_STATE_FLAGS_MASK)) {
> +            return H_PARAMETER;
> +        }
> +
> +        if (flags & H_GUEST_GET_STATE_FLAGS_HOST_WIDE) {
> +            gsr.flags |=3D GUEST_STATE_REQUEST_HOST_WIDE;
> +        }
> +    }
> +
> +    if (!(gsr.flags & GUEST_STATE_REQUEST_HOST_WIDE)) {
> +        guest =3D spapr_get_nested_guest(spapr, lpid);
> +        if (!guest) {
> +            return H_P2;
> +        }
>      }
>      return map_and_getset_state(cpu, guest, vcpuid, &gsr);
>  }
> diff --git a/include/hw/ppc/spapr_nested.h b/include/hw/ppc/spapr_nested.=
h
> index e420220484..217376a979 100644
> --- a/include/hw/ppc/spapr_nested.h
> +++ b/include/hw/ppc/spapr_nested.h
> @@ -11,7 +11,13 @@
>  #define GSB_TB_OFFSET           0x0004 /* Timebase Offset */
>  #define GSB_PART_SCOPED_PAGETBL 0x0005 /* Partition Scoped Page Table */
>  #define GSB_PROCESS_TBL         0x0006 /* Process Table */
> -                    /* RESERVED 0x0007 - 0x0BFF */
> +                    /* RESERVED 0x0007 - 0x07FF */
> +#define GSB_GUEST_HEAP          0x0800 /* Guest Management Heap Size */
> +#define GSB_GUEST_HEAP_MAX      0x0801 /* Guest Management Heap Max Size=
 */
> +#define GSB_GUEST_PGTABLE_SIZE  0x0802 /* Guest Pagetable Size */
> +#define GSB_GUEST_PGTABLE_SIZE_MAX   0x0803 /* Guest Pagetable Max Size =
*/
> +#define GSB_GUEST_PGTABLE_RECLAIM    0x0804 /* Pagetable Reclaim in byte=
s */

Could these names be changed so it's a bit more obvious that they
are "hostwide" stats? GSB_L0_GUEST_MAX, for example?

Also maybe call them GSB_L0_GUEST_HEAP_INUSE, PGTABLE_SIZE_INUSE,
and PGTABLE_RECLAIMED to be slightly clearer about them.

> +                    /* RESERVED 0x0805 - 0xBFF */
>  #define GSB_VCPU_IN_BUFFER      0x0C00 /* Run VCPU Input Buffer */
>  #define GSB_VCPU_OUT_BUFFER     0x0C01 /* Run VCPU Out Buffer */
>  #define GSB_VCPU_VPA            0x0C02 /* HRA to Guest VCPU VPA */
> @@ -196,6 +202,13 @@ typedef struct SpaprMachineStateNested {
>  #define NESTED_API_PAPR    2
>      bool capabilities_set;
>      uint32_t pvr_base;
> +    /* Hostwide counters */
> +    uint64_t current_guest_heap;
> +    uint64_t max_guest_heap;
> +    uint64_t current_pgtable_size;
> +    uint64_t max_pgtable_size;
> +    uint64_t pgtable_reclaim_size;

Similar for these names, I would keep them relatively
consistent with the #define names unless there is a
reason to change.

guest_heap_inuse, guest_heap_max, etc.

Looks pretty good though.

Thanks,
Nick

> +
>      GHashTable *guests;
>  } SpaprMachineStateNested;
> =20
> @@ -229,9 +242,15 @@ typedef struct SpaprMachineStateNestedGuest {
>  #define HVMASK_HDEXCR                 0x00000000FFFFFFFF
>  #define HVMASK_TB_OFFSET              0x000000FFFFFFFFFF
>  #define GSB_MAX_BUF_SIZE              (1024 * 1024)
> -#define H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE 0x8000000000000000
> -#define GUEST_STATE_REQUEST_GUEST_WIDE       0x1
> -#define GUEST_STATE_REQUEST_SET              0x2
> +#define H_GUEST_GET_STATE_FLAGS_MASK   0xC000000000000000ULL
> +#define H_GUEST_SET_STATE_FLAGS_MASK   0x8000000000000000ULL
> +#define H_GUEST_SET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
> +#define H_GUEST_GET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
> +#define H_GUEST_GET_STATE_FLAGS_HOST_WIDE  0x4000000000000000ULL
> +
> +#define GUEST_STATE_REQUEST_GUEST_WIDE     0x1
> +#define GUEST_STATE_REQUEST_HOST_WIDE      0x2
> +#define GUEST_STATE_REQUEST_SET            0x4
> =20
>  /*
>   * As per ISA v3.1B, following bits are reserved:
> @@ -251,6 +270,15 @@ typedef struct SpaprMachineStateNestedGuest {
>      .copy =3D (c)                                    \
>  }
> =20
> +#define GSBE_NESTED_MACHINE_DW(i, f)  {                             \
> +        .id =3D (i),                                                  \
> +        .size =3D 8,                                                  \
> +        .location =3D get_machine_ptr,                                \
> +        .offset =3D offsetof(struct SpaprMachineStateNested, f),     \
> +        .copy =3D copy_state_8to8,                                    \
> +        .mask =3D HVMASK_DEFAULT                                      \
> +}
> +
>  #define GSBE_NESTED(i, sz, f, c) {                             \
>      .id =3D (i),                                                 \
>      .size =3D (sz),                                              \
> @@ -509,7 +537,8 @@ struct guest_state_element_type {
>      uint16_t id;
>      int size;
>  #define GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE 0x1
> -#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY  0x2
> +#define GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE 0x2
> +#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY 0x4
>     uint16_t flags;
>      void *(*location)(SpaprMachineStateNestedGuest *, target_ulong);
>      size_t offset;


