Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A3837256D
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 May 2021 07:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhEDF1Z (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 4 May 2021 01:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDF1Z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 4 May 2021 01:27:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B577C061574
        for <kvm-ppc@vger.kernel.org>; Mon,  3 May 2021 22:26:30 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e2so4195219plh.8
        for <kvm-ppc@vger.kernel.org>; Mon, 03 May 2021 22:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=6z5nHoo/tCCuNRDjKYAHjek4wA0FT8tyb9dnvsuvr2k=;
        b=QGVxmngjWiP1gR5vT6ekl/Axm+mWdgujfYBQYZLdQEnQzPxsP1eCAtkxm/uOUOHByQ
         C41Slr1ld2UoE5I9Md+rVhAcAT0UWG0saKrWzNe1y9qO7GDSTQn5ElPHKP7CA6AO46Qp
         xU9EUk7K3Wnl6zY5YRo2ndPxL+NDgCk+Cl3crTaCf27vmUbh8QQA36octLumN7DtNkOh
         pdAuhSvnK6GdGUASZ6RZun3uYo7f7FBPwu8JDZfT/0rvm54kPcFArah7xzXNI65kD4Sw
         yYIg5Aqw4CMK9JuSJJGET9GH1sL+jWAXrbDaOXCoozfEgaRGP20483g3Z3WSDhfRSY/x
         s4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=6z5nHoo/tCCuNRDjKYAHjek4wA0FT8tyb9dnvsuvr2k=;
        b=iwKASlgm0RCimFLy8MPpiQ8PqL6KZUBni7PUnJc5vxID0mcQCmmm4Lb+rsMoVq915s
         nh6iJTUc4hEzHCg1g44vUcfTDekKw1K7Hk4vnp8VZkzwgsTgIH+e1t/DiiNnVX/erP+N
         c+cW9fG51fYHT5s0oFY/vDyvjB426VKpnhADLqhyXi2Y6s8qylnbvh0B2IslxnOD4DNR
         KPCHUFmi2eeapMSy6M7Vue2CUit6oxfcryDExs6fElqQCgvyfdcplqdUDk03rf1KIDyT
         hUiUm4eOQ7kt/6D43xsU5I21YiDtMzsM6tghqxnh7urqG/4yTIhRoYRXVFPZYa9npM2p
         UOcg==
X-Gm-Message-State: AOAM531hZKvsQiS+LLvUb4O6l6oa/f7aBLEoPCrmgnc26q3u/b/zeWqo
        TOpsOOJtRqfDB5TNmXYO+Lv+uuoD3Is=
X-Google-Smtp-Source: ABdhPJyiwoYCCGL9IF5a52YArUljkVB5biWW9/k/HSb5pPmATWfTVGVJpDd7Mv0Hoh1/M9oSyVTtoA==
X-Received: by 2002:a17:902:7683:b029:ec:a434:1921 with SMTP id m3-20020a1709027683b02900eca4341921mr23873281pll.67.1620105989826;
        Mon, 03 May 2021 22:26:29 -0700 (PDT)
Received: from localhost ([61.68.127.20])
        by smtp.gmail.com with ESMTPSA id v22sm10920069pff.105.2021.05.03.22.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 22:26:29 -0700 (PDT)
Date:   Tue, 04 May 2021 15:26:24 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: PPC: Book3S HV: Sanitise vcpu registers in
 nested path
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
References: <20210415230948.3563415-1-farosas@linux.ibm.com>
        <20210415230948.3563415-2-farosas@linux.ibm.com>
        <1619833560.k4eybr40bg.astroid@bobo.none>
        <YJDNbFQlB9DHnI6Z@thinks.paulus.ozlabs.org>
In-Reply-To: <YJDNbFQlB9DHnI6Z@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1620105163.ok9nw6k5yz.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of May 4, 2021 2:28 pm:
> On Sat, May 01, 2021 at 11:58:36AM +1000, Nicholas Piggin wrote:
>> Excerpts from Fabiano Rosas's message of April 16, 2021 9:09 am:
>> > As one of the arguments of the H_ENTER_NESTED hypercall, the nested
>> > hypervisor (L1) prepares a structure containing the values of various
>> > hypervisor-privileged registers with which it wants the nested guest
>> > (L2) to run. Since the nested HV runs in supervisor mode it needs the
>> > host to write to these registers.
>> >=20
>> > To stop a nested HV manipulating this mechanism and using a nested
>> > guest as a proxy to access a facility that has been made unavailable
>> > to it, we have a routine that sanitises the values of the HV registers
>> > before copying them into the nested guest's vcpu struct.
>> >=20
>> > However, when coming out of the guest the values are copied as they
>> > were back into L1 memory, which means that any sanitisation we did
>> > during guest entry will be exposed to L1 after H_ENTER_NESTED returns.
>> >=20
>> > This patch alters this sanitisation to have effect on the vcpu->arch
>> > registers directly before entering and after exiting the guest,
>> > leaving the structure that is copied back into L1 unchanged (except
>> > when we really want L1 to access the value, e.g the Cause bits of
>> > HFSCR).
>> >=20
>> > Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>> > ---
>> >  arch/powerpc/kvm/book3s_hv_nested.c | 55 ++++++++++++++++++----------=
-
>> >  1 file changed, 34 insertions(+), 21 deletions(-)
>> >=20
>> > diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/bo=
ok3s_hv_nested.c
>> > index 0cd0e7aad588..270552dd42c5 100644
>> > --- a/arch/powerpc/kvm/book3s_hv_nested.c
>> > +++ b/arch/powerpc/kvm/book3s_hv_nested.c
>> > @@ -102,8 +102,17 @@ static void save_hv_return_state(struct kvm_vcpu =
*vcpu, int trap,
>> >  {
>> >  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
>> > =20
>> > +	/*
>> > +	 * When loading the hypervisor-privileged registers to run L2,
>> > +	 * we might have used bits from L1 state to restrict what the
>> > +	 * L2 state is allowed to be. Since L1 is not allowed to read
>> > +	 * the HV registers, do not include these modifications in the
>> > +	 * return state.
>> > +	 */
>> > +	hr->hfscr =3D ((~HFSCR_INTR_CAUSE & hr->hfscr) |
>> > +		     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
>> > +
>> >  	hr->dpdes =3D vc->dpdes;
>> > -	hr->hfscr =3D vcpu->arch.hfscr;
>> >  	hr->purr =3D vcpu->arch.purr;
>> >  	hr->spurr =3D vcpu->arch.spurr;
>> >  	hr->ic =3D vcpu->arch.ic;
>>=20
>> Do we still have the problem here that hfac interrupts due to bits clear=
ed
>> by the hfscr sanitisation would have the cause bits returned to the L1,
>> so in theory it could probe hfscr directly that way? I don't see a good
>> solution to this except either have the L0 intercept these faults and do
>> "something" transparent, or return error from H_ENTER_NESTED (which woul=
d
>> also allow trivial probing of the facilities).
>=20
> It seems to me that there are various specific reasons why L0 would
> clear HFSCR bits, and if we think about the specific reasons, what we
> should do becomes clear.  (I say "L0" but in fact the same reasoning
> applies to any hypervisor that lets its guest do hypervisor-ish
> things.)
>=20
> 1. Emulating a version of the architecture which doesn't have the
> feature in question - in that case the bit should appear to L1 as a
> reserved bit in HFSCR (i.e. always read 0), the associated facility
> code should never appear in the top 8 bits of any HFSCR value that L1
> sees, and any HFU interrupt received by L0 for the facility should be
> changed into an illegal instruction interrupt (or HEAI) forwarded to
> L1.  In this case the real HFSCR should always have the enable bit for
> the facility set to 0.
>=20
> 2. Lazy save/restore of the state associated with a facility - in this
> case, while the system is in the "lazy" state (i.e. the state is not
> that of the currently running guest), the real HFSCR bit for the
> facility should be 0.  On an HFU interrupt for the facility, L0 looks
> at L1's HFSCR value: if it's 0, forward the HFU interrupt to L1; if
> it's 1, load up the facility state, set the facility's bit in HFSCR,
> and resume the guest.
>=20
> 3. Emulating a facility in software - in this case, the real HFSCR
> bit for the facility would always be 0.  On an HFU interrupt, L0 reads
> the instruction and emulates it, then resumes the guest.
>=20
> One thing this all makes clear is that the IC field of the "virtual"
> HFSCR value seen by L1 should only ever be changed when L0 forwards a
> HFU interrupt to L1.
>=20
> In fact we currently never do (1) or (2), and we only do (3) for
> msgsndp etc., so this discussion is mostly theoretical.

Yeah it's somewhat theoretical, and I guess I mostly agree with you.

Missing is the case where the L0 does not implement a feature at all.
Let's say TM is broken so it disables it, or nobody uses TAR so it=20
doesn't bother to switch it.

In those cases what do you tell the L1 if it enables a bit that you
don't support at all, and it takes a fault?

I guess the right thing to do is advertise that to the guest by some
other means, and expect it does the right thing. And you could have
the proviso in the nested HV specification that the returned IC field
might trip for a feature you enabled in the L1 HFSCR.

>=20
>> Returning an hfac interrupt to a hypervisor that thought it enabled the=20
>> bit would be strange. But so does appearing to modify the register=20
>> underneath it and then returning a fault.
>=20
> I don't think we should ever do either of those things.  The closest
> would be (1) above, but in that case the fault has to be either an
> illegal instruction type program interrupt, or a HEAI.
>=20
>> I think the sanest thing would actually be to return failure from the=20
>> hcall.
>=20
> I don't think we should do that either.

I still think it's preferable for case 4. No point waiting for the
guest to boot and some user program eventually hits a bad instruction,
even if it was due to some host vs guest configuration problem.

At any rate, this patch 1 not overwriting the L2 HV state with the
sanitization step is fine and clearly required for any kind of non
trivial handling of missing bits.

Thanks,
Nick
