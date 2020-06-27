Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C5120C298
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Jun 2020 17:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgF0O7s (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 27 Jun 2020 10:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgF0O7s (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 27 Jun 2020 10:59:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6773C061794
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 07:59:47 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so12024549wml.3
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 07:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=wdLyniBgRhGvcPSWodPXRkUHWf+cL8Zwo2freFFNrwY=;
        b=IIkYsAjs3O8Ze+lMtA++914lTKyOOZhWrKkOhgqTuhbnpF7w/G14n70dx5d5tYLx5O
         F5EZ211rUkkGtQnxien32nXYqn+01OgW2HIO9imS/oQHQsMsFw3gTzJtYyNdqO4T6EHU
         AWTGh5/yqV8ZAukEgARp8jbVbzXop593ZxYQLU2tCz8ekmGPXyKg7kQj6ymOpX5wCCY0
         a342V7SQU2QElOO3EZLVUGo0f4o11n2znPTyMhlp/15Q607qErTD/waVa4bh/mjBtP8N
         AimFSFh/IQwKr1hSoeY4xVENXCCrEMbxjjPbU3NTOWaMiS9yos7v5cM26oYxGVr8gfCZ
         sOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=wdLyniBgRhGvcPSWodPXRkUHWf+cL8Zwo2freFFNrwY=;
        b=bREyrSZCa5gkGRIRSxB3dyAY2ADfXEKWFAqL01dao2jh1JW8+SLdTDX4yWybIyJbOE
         fhfEZs/rXxbTsPsGWDj6/ekFSFLSm92E5JxgmWgac8qOZ7/ADtue9lxwU0A5B1+3qCM3
         RMDL1YmtUeff8TpnIFMTvtDB+RgRU+pzF0bI1Wf2B1H7ktL4dosd/zg0LvblhfOLE4kX
         S3dWbsTSeFCjNdoRra8URi91BenGBwo5Dcu77AgqV9jcvkyp7yYj0nj3nA0mO/T3B/Bd
         whnccfA10/B0IJifukeVBA95iAPqJ0LWH+tHF2N/fLFWHb6i4mFvMdQR1sx9N1uFdNPi
         JObQ==
X-Gm-Message-State: AOAM530vhco1/KDMWi/48eaIoNfgIbWHm3JLG8lgI1hcijO/Wxcz8Bmm
        qEaBMjiaGajMAtUr6CbfDbo=
X-Google-Smtp-Source: ABdhPJz6dCmPxPqY/YqnbJ1xaKiGwByNa14CTNgluVJnQPt++a+zuNhtzKRgCuOAyVxwBCTGC0xnEQ==
X-Received: by 2002:a1c:f608:: with SMTP id w8mr8306425wmc.78.1593269985454;
        Sat, 27 Jun 2020 07:59:45 -0700 (PDT)
Received: from localhost (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id l132sm21512156wmf.6.2020.06.27.07.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 07:59:44 -0700 (PDT)
Date:   Sun, 28 Jun 2020 00:59:37 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] powerpc/pseries: Use doorbells even if XIVE is available
To:     =?iso-8859-1?q?C=E9dric?= Le Goater <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org
References: <20200624134724.2343007-1-npiggin@gmail.com>
        <87r1u4aqzm.fsf@mpe.ellerman.id.au>
        <af42c250-cf4b-0815-c91c-9363445383e7@kaod.org>
In-Reply-To: <af42c250-cf4b-0815-c91c-9363445383e7@kaod.org>
MIME-Version: 1.0
Message-Id: <1593269745.ooncxk6m0x.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from C=C3=A9dric Le Goater's message of June 26, 2020 5:17 pm:
> Adding David,=20
>=20
> On 6/25/20 3:11 AM, Michael Ellerman wrote:
>> Nicholas Piggin <npiggin@gmail.com> writes:
>>> KVM supports msgsndp in guests by trapping and emulating the
>>> instruction, so it was decided to always use XIVE for IPIs if it is
>>> available. However on PowerVM systems, msgsndp can be used and gives
>>> better performance. On large systems, high XIVE interrupt rates can
>>> have sub-linear scaling, and using msgsndp can reduce the load on
>>> the interrupt controller.
>>>
>>> So switch to using core local doorbells even if XIVE is available.
>>> This reduces performance for KVM guests with an SMT topology by
>>> about 50% for ping-pong context switching between SMT vCPUs.
>>=20
>> You have to take explicit steps to configure KVM in that way with qemu.
>> eg. "qemu .. -smp 8" will give you 8 SMT1 CPUs by default.
>>=20
>>> An option vector (or dt-cpu-ftrs) could be defined to disable msgsndp
>>> to get KVM performance back.
>=20
> An option vector would require a PAPR change. Unless the architecture=20
> reserves some bits for the implementation, but I don't think so. Same
> for CAS.
>=20
>> Qemu/KVM populates /proc/device-tree/hypervisor, so we *could* look at
>> that. Though adding PowerVM/KVM specific hacks is obviously a very
>> slippery slope.
>=20
> QEMU could advertise a property "emulated-msgsndp", or something similar,=
=20
> which would be interpreted by Linux as a CPU feature and taken into accou=
nt=20
> when doing the IPIs.

What I'm going to do is detect KVM here (we already have a KVM detection
test using that dt property). The IPI setup code already has KVM hacks=20
in it, so I don't really see the problem with puting them behind a KVM
test.

I think doing cpu ftrs or some specific entry for msgsndp in particular
is the right way to go, but in the interests of making existing KVM work
I'll do this.

Thanks,
Nick
