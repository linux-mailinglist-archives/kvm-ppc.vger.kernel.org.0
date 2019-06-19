Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B384B04A
	for <lists+kvm-ppc@lfdr.de>; Wed, 19 Jun 2019 04:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFSC7b (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jun 2019 22:59:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46095 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFSC7b (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 Jun 2019 22:59:31 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so8799236pfy.13
        for <kvm-ppc@vger.kernel.org>; Tue, 18 Jun 2019 19:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=C4X1ym1QFdGSOLkNteju5WcuJojsqRIFv5cOkh0y02M=;
        b=vZY+X5P9Rs5SST3rNJXcc2iRlWeuWE01xHKQZoiWKriAogeOUF7k8EuOYCA9djhvxH
         mUQ4uDyuIdVqHTxpGft6iA8nXr8bKDbM7qUh0XvyhE9WZOUR5EjIWwSyU1BThHfgANLP
         o15YgKwLw7cFkBBjnpSH4pHFrd2lAsF9th2qp1A/pr4AnJBpsMyAMBZPAPEfNZfS9ulE
         xnmPykYspfvgFMLP33U6gQZ7dBZ2OtPYQY6gKwVUkaSIFPGfFuiNTV2n7VPuW4GNnpbo
         gLL63JjL46H+MKGN50m/wyuIxzXJpWMaJHU2In4S65z5pGJlRuPhNckw7Y01U6yyQdzh
         5ZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=C4X1ym1QFdGSOLkNteju5WcuJojsqRIFv5cOkh0y02M=;
        b=rRRplNV+fSONkivmxr5z66VXy2055YTQMqGWSnWfck1gQDs0mGUhmOw8dXL9Hoos06
         y01GgnRtFK3nPP26lDyMayuZatW/+dSYkNqOjAtm6JQAIDHQwaS6ObOsu1rCfzKr3lUD
         nIG220ImZtRNp/vEgFYi377pw8n1JOC3J+0WoQoLGYZQ/hCerueUQEr1eub34arJqzK1
         TuzUylth8wLqwBu7SpV+VAC00yLMVf0CBs/E3HqNuYDalTcfYfKBDmDCTgfKgBKNsQyo
         U6HhizB2ulQ+R4gnYM3lKDHt9Di4pFCdVsfaUQRn76iZJZxj1i3zgITO2moQHnfAN6MO
         V8Fg==
X-Gm-Message-State: APjAAAXdJ/v3eOuavhuXU8dx37MEEp3DIJXDT8wiZh0tnUxv4hHnENpn
        1DIFU+p5G8dTaEVUWDrzDonupm+mZ0I=
X-Google-Smtp-Source: APXvYqzXr9UPVjWkDMmtvRyU/swaoy2A8X26cFUCK8XthWSe86SOn3fgP8EpeBVq1nKvZnVXLyupyA==
X-Received: by 2002:a17:90a:8a8e:: with SMTP id x14mr8427318pjn.103.1560913171110;
        Tue, 18 Jun 2019 19:59:31 -0700 (PDT)
Received: from localhost (193-116-92-108.tpgi.com.au. [193.116.92.108])
        by smtp.gmail.com with ESMTPSA id p7sm31173654pfp.131.2019.06.18.19.59.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 19:59:30 -0700 (PDT)
Date:   Wed, 19 Jun 2019 12:54:27 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/5] KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt
 for async guest delivery
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org
References: <20190520005659.18628-1-npiggin@gmail.com>
        <20190520005659.18628-3-npiggin@gmail.com>
        <20190617014527.dlbhru4tads7tdhc@oak.ozlabs.ibm.com>
In-Reply-To: <20190617014527.dlbhru4tads7tdhc@oak.ozlabs.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1560912705.l6p64snk7r.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Paul Mackerras's on June 17, 2019 11:45 am:
> On Mon, May 20, 2019 at 10:56:57AM +1000, Nicholas Piggin wrote:
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> Comment below...
>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/boo=
k3s_hv_builtin.c
>> index 6035d24f1d1d..5ae7f8359368 100644
>> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
>> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
>> @@ -758,6 +758,53 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *s=
ip)
>>  	local_paca->kvm_hstate.kvm_split_mode =3D NULL;
>>  }
>> =20
>> +static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.ceded =3D 0;
>> +	if (vcpu->arch.timer_running) {
>> +		hrtimer_try_to_cancel(&vcpu->arch.dec_timer);
>=20
> So now we're potentially calling hrtimer_try_to_cancel in real mode.
> Are you absolutely sure that nothing in the hrtimer code accesses
> anything that is vmalloc'd?  I'm not.  Maybe you can prove that when
> called in real mode, vcpu->arch.timer_running will always be false,
> but it seems fragile to me.

Good point, no we shouldn't do this.

Is the guest always going to be out of cede at this point? Possibly
just a variant of the function that doesn't end cede would be the
go.

Thanks,
Nick
=
