Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71C136B253
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Apr 2021 13:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhDZL2G (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 26 Apr 2021 07:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhDZL2G (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 26 Apr 2021 07:28:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FE3C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 26 Apr 2021 04:27:25 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b21so261748plz.0
        for <kvm-ppc@vger.kernel.org>; Mon, 26 Apr 2021 04:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:mime-version:message-id
         :content-transfer-encoding;
        bh=WojHIOCE9IiTbGPzqxYFTTTCnqu0elAJH1s4+uNOyEQ=;
        b=J0qyEGaT/rxkDjFcDO08MAVfnAPIxzrvr3SopwvSmi8Kg5iAdQfEtv74oiHHIQS1iS
         CGLqfsIBlnJrP/15yYko6TCtMHOz/ntk1azufroxAT5BsYlXp+RtQsaUbD73K+FQ1vZV
         zzsLUUNiT2vCss/eeZyE1ZUEL+trqdkNsenJcyDOQU44ca1oN7Rmvf5RUPhUPgWdhPJJ
         eqiWkRep4QEiwst/6jC0mQwsISQbu7EK5mJzTLyAmyJhEGlGuMBSU1sJvw6BJ5tfgRww
         XKx3RV+jNz+GN4YfzuCgcg0+VGRvXHeoWlC1N2IuwJYL4ggS7AYew65Xi8VPNUYfphvi
         RzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:mime-version:message-id
         :content-transfer-encoding;
        bh=WojHIOCE9IiTbGPzqxYFTTTCnqu0elAJH1s4+uNOyEQ=;
        b=W71n34ZdKjmSKgP98hsB0Sxn42/9ksQIlCOA5aej9KQ21CQUqt46ASlB3bhY/ytDz9
         pL0KovXWBuyVspAGWdI2PDzs0aCW+ZKNmh6Ei4wTUb/cVjSXEV3EfYAL2bBAsayjQcQm
         Q1AZstCz6R3AHNY7Q1VjB7qQrikRSVmxy2SEBU2R5Yd2x0VruKevhKJP4HzueRJIFldc
         c+8+hIAbCWUrfVjEIHJQURQInBjl+UCY2JgBuboxhW/Isz5Ul35EzA2UCcX1Hk+k92Ut
         y4YiCEHi1wx6Mcc0VkPxmMBhCMEl7pnhqx8Zd7DliFDSGbdeFwsW1yw32LQ4SA/wo050
         kO1g==
X-Gm-Message-State: AOAM532pX8l05kEwAGPfJEuudQy/aOFOtXN0ZBOLoJmfC9Px6uWS76pu
        85mfnWyzYyLd6o9cm0qPDFsOinh5irk=
X-Google-Smtp-Source: ABdhPJxhCUd6Iz5KibdnBFl8Aeh3Pkjodv3kU3GM9TTu89lVrTHu03yLezPM6rMYrMwwWgtdYFJtGQ==
X-Received: by 2002:a17:90a:d707:: with SMTP id y7mr22928289pju.50.1619436444496;
        Mon, 26 Apr 2021 04:27:24 -0700 (PDT)
Received: from localhost ([59.102.87.99])
        by smtp.gmail.com with ESMTPSA id a7sm11167389pfg.65.2021.04.26.04.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:27:24 -0700 (PDT)
Date:   Mon, 26 Apr 2021 21:27:18 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Guest entry/exit performance work and observations
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
MIME-Version: 1.0
Message-Id: <1619432976.tfqsjlu7r9.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

I'm looking at KVM HV P9 path guest exit/entry performance with the Cify
patches, plus some further work to see what we can do.

Measurement is done in the guest making a "NULL hcall" and return back=20
to a non-nested guest. Two cases considered: First, returning to guest=20
at the "try_real_mode" hcall handler. Second, returning back to guest=20
after going around a loop in kvmppc_vcpu_run_hv (i.e., exit into full=20
host kernel context, but not to host usermode).

The real-mode test is a proxy for real mode hcall and other interrupt
handlers, and the full exit is a proxy for virtual mode hcalls and=20
interrupt handlers.

The test was done with powernv_defconfig, radix guest and radix host on
a POWER9 with meltdown mitigations disabled. A minor hack was made
just to get the immediate return / NULL hcall behaviour to measure
performance.

* Upstream try_real_mode return	-  509 cycles
* Upstream virt NULL hcall	- 9587 cycles
* KVM Cify virt NULL hcall	- 9333 cycles
* KVM Cify+opt virt NULL hcall	- 5754 cycles (167% faster than upstream,
				               or 60% the cycles required)

The KVM Cify series (which you have already seen) plus the further
optimisations patch series is here:

https://github.com/npiggin/linux/tree/kvm-in-c-new

Some of the important / major further optimisation patches have
individual cycle time improvement contribution annotated. In many cases
things are inter-dependent, e.g., patch A might improve 100 cycles and
B 50 cycles but A+B might be 250 due to together avoiding an SPR stall.
So take the individual numbers with a grain of salt, and the cumulative
result above is most important.

In summary the Cify series does not hurt performance of entry/exit,=20
which is good. It actually helps a bit, I'm not sure exactly where.
And we can make quite a lot more improvement with this series.

HOWEVER! The Cify series removes the very fast real mode hcall and=20
interrupt handlers (except some things like machine check). So any real=20
mode handler will be handled as a virt mode handler on P9 after Cify.

Now I have some further patches in progress that should shave about 1000=20
more cycles more from the full exit, but beyond that it gets pretty=20
tough to improve. That still leaves it an order of magnitude slower. =20

Now I did say this doesn't matter so much with a P9/radix/xive guest
which is true, except possibly for TCE hcalls that Alexey brought to my
attention (any other important cases?). So we will have to think about=20
that.

Alexey did say that the real mode TCE hcalls were added for P8, and
were less important for P9, but it is something to keep an eye on. We=20
might end up adding a faster handler back, but I would much prefer if
wasn't entirely run in guest context as they do today (maybe switch
MMU context, TB, and a few other important SPRs, and enable translation
so it can run practically as host kernel context). But I think we should
wait and see, and add the complexity only if it comes up as a problem.

The other thing is the P9 path now implements the P9 hash guest support=20
after the Cify series. Hash does a lot more exits due to translation=20
hcalls and interrupts. I did do some basic measurements (e.g., kernel=20
compile) and couldn't see a significant slowdown. But in any case I=20
think the P9 hash code is not important to micro optimise, it was only
done to simplify code and remove asm, so I would rather not add=20
complexity for that.

Thanks,
Nick
