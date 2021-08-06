Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FBF3E2834
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 12:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244928AbhHFKJ6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 06:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244930AbhHFKJw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 06:09:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64637C06179C
        for <kvm-ppc@vger.kernel.org>; Fri,  6 Aug 2021 03:09:37 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d1so6446921pll.1
        for <kvm-ppc@vger.kernel.org>; Fri, 06 Aug 2021 03:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Qo8+DXARQmZvi0+oDjqz884CmgevIsmESsdKCqREcgM=;
        b=Zctwj8I3SU5NOmdoMrreDhqJ60J3O8nmSt9U2VRjjHFQ4bsj18C4fT4+h9MOWP8Ra2
         9fRPdwtlloa2tO16VTzdu3d/OD3moBoLGHxMDhD+kCvEli+TVGQnTg1YsE4mkCigBZqk
         OJCZhRKkx2l6KIX70Nykw0D5EX82/6MQ3mzr6aAaerYqmVeIORsV9cMmGN43tMlU7wWB
         vhbkUi9pWgRPCxpwScLLZ8BB1QUNxeq+HjsxKautSEJgTheA83Ivtjm+FtR2z5d2HTX0
         ioFkMb2mXsubwxWW8/2ib1CkkCNaJj+MuqUi+IE4DoCrHJcsHnjGyD7JaGpuPUcocW4g
         9GgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Qo8+DXARQmZvi0+oDjqz884CmgevIsmESsdKCqREcgM=;
        b=tqfbgIaJp/nOI/qOIvVt+nNHEcHG2G2Ynkz3KoXiizdta5Fiz5c/slE1Kb9MTWJpZi
         iJDnHCXd4rX/wGG7qK4EDdhGlMd/F72mPwdLcmYxlvjqYSISo8NYgPfNcHqtJAbG1mw/
         2tz/qSk7CFb+nNYm9wA+m3hoRbo3cYMrusB0mRzgS8leAfhNv3BxE2NXbTtk+tyE4+3h
         QqC4sDjVoTUfzpic+Y0LLZL12wCkrru1yxmOSNA/5eJwyII323x4tko5KzSsH4oNNnal
         YIMh/6tQMxoCBlN4OeGxG1/o5NLTs/dDt05DaYslck1Qb5SF2/4+3f/5Gac3rJvUm+xE
         3gzw==
X-Gm-Message-State: AOAM533gXbBWsL88Fp9rpZVAhd8xGQARgEbEZa8ytSqXzbKYNxig0ptJ
        eirfe9Xjsp7/kaNYevKRhHY=
X-Google-Smtp-Source: ABdhPJyStiXqC6J8AG8B7CVFAukaNA0o9kcxJ7ETvnfnz+TAJG9bKKV5IkeLeQ4qByJ2NQw34gINNg==
X-Received: by 2002:a17:90b:802:: with SMTP id bk2mr9737611pjb.51.1628244576979;
        Fri, 06 Aug 2021 03:09:36 -0700 (PDT)
Received: from localhost ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id f5sm8906820pjo.23.2021.08.06.03.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:09:36 -0700 (PDT)
Date:   Fri, 06 Aug 2021 20:09:31 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: PPC: Book3S HV: Fix copy_tofrom_guest
 routines
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     christophe.leroy@c-s.fr, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, paulus@ozlabs.org
References: <20210805212616.2641017-1-farosas@linux.ibm.com>
        <20210805212616.2641017-2-farosas@linux.ibm.com>
In-Reply-To: <20210805212616.2641017-2-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1628244553.dbzjakaq9m.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of August 6, 2021 7:26 am:
> The __kvmhv_copy_tofrom_guest_radix function was introduced along with
> nested HV guest support. It uses the platform's Radix MMU quadrants to
> provide a nested hypervisor with fast access to its nested guests
> memory (H_COPY_TOFROM_GUEST hypercall). It has also since been added
> as a fast path for the kvmppc_ld/st routines which are used during
> instruction emulation.
>=20
> The commit def0bfdbd603 ("powerpc: use probe_user_read() and
> probe_user_write()") changed the low level copy function from
> raw_copy_from_user to probe_user_read, which adds a check to
> access_ok. In powerpc that is:
>=20
>  static inline bool __access_ok(unsigned long addr, unsigned long size)
>  {
>          return addr < TASK_SIZE_MAX && size <=3D TASK_SIZE_MAX - addr;
>  }
>=20
> and TASK_SIZE_MAX is 0x0010000000000000UL for 64-bit, which means that
> setting the two MSBs of the effective address (which correspond to the
> quadrant) now cause access_ok to reject the access.
>=20
> This was not caught earlier because the most common code path via
> kvmppc_ld/st contains a fallback (kvm_read_guest) that is likely to
> succeed for L1 guests. For nested guests there is no fallback.
>=20
> Another issue is that probe_user_read (now __copy_from_user_nofault)
> does not return the number of bytes not copied in case of failure, so
> the destination memory is not being cleared anymore in
> kvmhv_copy_from_guest_radix:
>=20
>  ret =3D kvmhv_copy_tofrom_guest_radix(vcpu, eaddr, to, NULL, n);
>  if (ret > 0)                            <-- always false!
>          memset(to + (n - ret), 0, ret);
>=20
> This patch fixes both issues by skipping access_ok and open-coding the
> low level __copy_to/from_user_inatomic.
>=20
> Fixes: def0bfdbd603 ("powerpc: use probe_user_read() and probe_user_write=
()")

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/bo=
ok3s_64_mmu_radix.c
> index b5905ae4377c..44eb7b1ef289 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -65,10 +65,12 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpi=
d, int pid,
>  	}
>  	isync();
> =20
> +	pagefault_disable();
>  	if (is_load)
> -		ret =3D copy_from_user_nofault(to, (const void __user *)from, n);
> +		ret =3D __copy_from_user_inatomic(to, (const void __user *)from, n);
>  	else
> -		ret =3D copy_to_user_nofault((void __user *)to, from, n);
> +		ret =3D __copy_to_user_inatomic((void __user *)to, from, n);
> +	pagefault_enable();
> =20
>  	/* switch the pid first to avoid running host with unallocated pid */
>  	if (quadrant =3D=3D 1 && pid !=3D old_pid)
> --=20
> 2.29.2
>=20
>=20
