Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7BA3E2888
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 12:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245058AbhHFK0Y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 06:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhHFK0M (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 06:26:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEE2C061798
        for <kvm-ppc@vger.kernel.org>; Fri,  6 Aug 2021 03:25:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nh14so15927714pjb.2
        for <kvm-ppc@vger.kernel.org>; Fri, 06 Aug 2021 03:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=vHll5hrt3Tfly15sgVwP9BPUg47NmiSrfXLIjuKEQUM=;
        b=gq4wjpiUFInOKrTRlCcgF6CknZ3cxsY70MMCFtuxK0AhApZXWjrTPNZ47uBAvZeINN
         zJ8jtDZCQt/nHqROQ6zHxypX9H+rVCQFpRfGZedLoN0M4/an3nRVMPwPLmLpCvPytqiq
         E5DKxuYFNDNkIftQBOFVtlylSMzrkS51tBRsr+G34l0P0may2EDba6TuV3ZDYko41TCu
         9g4yAs7hQel73gtcnDL1bKXzqICCX06knQRlX15qj4FVNPYsXR8MPCuJBm2wnVEwG0YW
         VsC1etPm46U1y4FaX3H1PwZszyDbG9F0hCSv2GIn71IkQDKEuzhjNK4tIjXnCigijiRL
         NtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=vHll5hrt3Tfly15sgVwP9BPUg47NmiSrfXLIjuKEQUM=;
        b=OQX7xFYD85ttw68dF5v5bcfaRtsTbH7Lj3elCg0h8HekMcUdJtXo28TIaM+UOLugF8
         v/PJfuU3z56IB5Wonev+1khUJbbfdhlboprEhfu6Yjb5RaijJtYNSSsGiDRHMwsRDiHv
         asjlVMX77H4ui2zQ8fj0AfWDZ399PpJH1JVLa2KCqgzVCZqr9pCKVUdxKF3Vj142/dym
         teg2+MSItmD6f5Ko5WACao18TK+yQYLWV94O5BZJmuLZZe2VgAHsibSxQvsbeJRoqV2z
         lQAs2c4L6NX79f76wIr8BRK/QQFp62WAJZDygzVmn7hz2w+mqgOzoVTWHkC8NxE00L9k
         fDyg==
X-Gm-Message-State: AOAM533KTb0JfdsPQaylWwryLM1cSVwD0y9JaJHTdx22Sd/C/Gh+1LVk
        ySoLPzkCaeDVciMrfvdZXfENJXoWTe8=
X-Google-Smtp-Source: ABdhPJzIe0qERi8yRm9ql31ipjDJSifEYxG6SeBMdDKSp1TntY2Li7isVSW/J9ygD35MG7BuKiQ0XA==
X-Received: by 2002:a63:171d:: with SMTP id x29mr127688pgl.418.1628245550936;
        Fri, 06 Aug 2021 03:25:50 -0700 (PDT)
Received: from localhost ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id p2sm10259487pfn.141.2021.08.06.03.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:25:50 -0700 (PDT)
Date:   Fri, 06 Aug 2021 20:25:45 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v1 02/55] KVM: PPC: Book3S HV P9: Fixes for TM softpatch
 interrupt
To:     kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210726035036.739609-1-npiggin@gmail.com>
        <20210726035036.739609-3-npiggin@gmail.com>
        <87a6lvnzin.fsf@mpe.ellerman.id.au>
In-Reply-To: <87a6lvnzin.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Message-Id: <1628244726.vqhkwwlqv7.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Michael Ellerman's message of August 6, 2021 11:16 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>> The softpatch interrupt sets HSRR0 to the faulting instruction +4, so
>> it should subtract 4 for the faulting instruction address. Also have it
>> emulate and deliver HFAC interrupts correctly, which is important for
>> nested HV and facility demand-faulting in future.
>=20
> The nip being off by 4 sounds bad. But I guess it's not that big a deal
> because it's only used for reporting the instruction address?

Yeah currently I think so. It's not that bad of a bug.

>=20
> Would also be good to have some more explanation of why it's OK to
> change from illegal to HFAC, which is a guest visible change.

Good point. Again for now it doesn't really matter because the HFAC
handler turns everything (except msgsndp) into a sigill anyway, so
becomes important when we start using HFACs. Put that way I'll probably
split it out.

>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_h=
v_tm.c
>> index cc90b8b82329..e4fd4a9dee08 100644
>> --- a/arch/powerpc/kvm/book3s_hv_tm.c
>> +++ b/arch/powerpc/kvm/book3s_hv_tm.c
>> @@ -74,19 +74,23 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
>>  	case PPC_INST_RFEBB:
>>  		if ((msr & MSR_PR) && (vcpu->arch.vcore->pcr & PCR_ARCH_206)) {
>>  			/* generate an illegal instruction interrupt */
>> +			vcpu->arch.regs.nip -=3D 4;
>>  			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
>>  			return RESUME_GUEST;
>>  		}
>>  		/* check EBB facility is available */
>>  		if (!(vcpu->arch.hfscr & HFSCR_EBB)) {
>> -			/* generate an illegal instruction interrupt */
>> -			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
>> -			return RESUME_GUEST;
>> +			vcpu->arch.regs.nip -=3D 4;
>> +			vcpu->arch.hfscr &=3D ~HFSCR_INTR_CAUSE;
>> +			vcpu->arch.hfscr |=3D (u64)FSCR_EBB_LG << 56;
>> +			vcpu->arch.trap =3D BOOK3S_INTERRUPT_H_FAC_UNAVAIL;
>> +			return -1; /* rerun host interrupt handler */
>=20
> This is EBB not TM. Probably OK to leave it in this patch as long as
> it's mentioned in the change log?

It is, but you can get a softpatch interrupt on rfebb changing TM state.=20
Although I haven't actually tested to see if you get a softpatch when
HFSCR disables EBB or the hardware just gives you the HFAC. For that=20
matter, same for all the other facility tests.

Thanks,
Nick

>=20
>>  		}
>>  		if ((msr & MSR_PR) && !(vcpu->arch.fscr & FSCR_EBB)) {
>>  			/* generate a facility unavailable interrupt */
>> -			vcpu->arch.fscr =3D (vcpu->arch.fscr & ~(0xffull << 56)) |
>> -				((u64)FSCR_EBB_LG << 56);
>> +			vcpu->arch.regs.nip -=3D 4;
>> +			vcpu->arch.fscr &=3D ~FSCR_INTR_CAUSE;
>> +			vcpu->arch.fscr |=3D (u64)FSCR_EBB_LG << 56;
>=20
> Same.
>=20
>=20
> cheers
>=20
