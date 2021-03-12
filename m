Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D134338311
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Mar 2021 02:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCLBOD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Mar 2021 20:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhCLBNu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Mar 2021 20:13:50 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE42C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Mar 2021 17:13:50 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t37so3992465pga.11
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Mar 2021 17:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=fqgBQHGszJ1FJ/uJtib9M0dApRy7K5pmtaH0QVQ6w/E=;
        b=vdo0+wYIjZgxN1DHiAduyEanAb6xMs7pl6PHFhUQVCmfAgFSd2RNbjOFKI/L1rY+92
         hbfV8nmYDxlPo4Ur59e8+a8ppAenabXc2eXQvPMoJwbmuWfNff114lZaw1Rg5sR6Veb2
         OI5S2IeOA8CDDZ5IpDFo37yWixEWNriAqpJ6r9UfE0wnO8Yhs0TwKr+MnPmlVYzgqDM2
         DzU85n0RBEbwMOAVZkPrOlO4l2MsSZ34OpXIviaFOUQVRJpLnEP3qbxFhVMudI83LkBZ
         qhGN/RzbgoWxMqaM4gMi/WK59gHt5PFl0d8MRsPR98rfbbhprDda1yazuiAzRVuoCH40
         yAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=fqgBQHGszJ1FJ/uJtib9M0dApRy7K5pmtaH0QVQ6w/E=;
        b=YtaGx0Nak4NPgCEjm9PYwcd/7AvqUHuNHwCoaX4MPpLFrvVE8WxpHEfH5tmcFDukQT
         ezSfg8FbIozo34zGQB618KT0Xl6afhI48kt9X3whUDhyzAzAg0fuB+1WaRVNH0EIU8TS
         kDwQ7LfYzRoruyLJkFaTDH6Rdp638Ve3D+ro07gup+H9vDx/61RZoAr84UiieoeHToju
         eAvF9PX6UTD4Po+co9djqRiPQQGdwqaUDqLvtGToFJmNya97dd4ugR06rpcMMcuTyH36
         RGv94HyqwmtZ5ivGucRfUlE55+k576hywyfbhNO+sq9TY7uqRnIoYktU9vP7MQOKyUN7
         BmyQ==
X-Gm-Message-State: AOAM532Hji+ngITPBDiI8EQmUtci3iRAfO3vQOjEI1soLjENaiut14QO
        8Y2InHdXBjoLoehK//PZB1TEqJU8DZU=
X-Google-Smtp-Source: ABdhPJx249OAggnX/6S8Z7M8WlaUjbknMaYUtqTYcwA9ec64iRZMMUHTncGO8vWthXzdUlABbTCjXA==
X-Received: by 2002:a62:35c2:0:b029:1f1:3a8b:83d5 with SMTP id c185-20020a6235c20000b02901f13a8b83d5mr10032240pfa.29.1615511629491;
        Thu, 11 Mar 2021 17:13:49 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id k8sm277545pjj.31.2021.03.11.17.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 17:13:48 -0800 (PST)
Date:   Fri, 12 Mar 2021 11:13:43 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Do not expose HFSCR sanitisation to
 nested hypervisor
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
References: <20210305231055.2913892-1-farosas@linux.ibm.com>
        <1615191200.1pjltfhe7o.astroid@bobo.none>
        <20210310092354.GA30597@blackberry>
In-Reply-To: <20210310092354.GA30597@blackberry>
MIME-Version: 1.0
Message-Id: <1615511004.vkyzd3ossi.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of March 10, 2021 7:23 pm:
> On Mon, Mar 08, 2021 at 06:18:47PM +1000, Nicholas Piggin wrote:
>> Excerpts from Fabiano Rosas's message of March 6, 2021 9:10 am:
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
>> > This is not a problem by itself, but in the case of the Hypervisor
>> > Facility Status and Control Register (HFSCR), we use the intersection
>> > between L2 hfscr bits and L1 hfscr bits. That means that L1 could use
>> > this to indirectly read the (hv-privileged) value from its vcpu
>> > struct.
>> >=20
>> > This patch fixes this by making sure that L1 only gets back the bits
>> > that are necessary for regular functioning.
>>=20
>> The general idea of restricting exposure of HV privileged bits, but
>> for the case of HFSCR a guest can probe the HFCR anyway by testing which=
=20
>> facilities are available (and presumably an HV may need some way to know
>> what features are available for it to advertise to its own guests), so
>> is this necessary? Perhaps a comment would be sufficient.
>=20
> I would see it a bit differently.  From L1's point of view, L0 is the
> hardware.  The situation we have now is akin to writing a value to the
> real HFSCR, then reading HFSCR and finding that some of the facility
> enable bits have magically got set to zero.  That's not the way real
> hardware works, so L0 shouldn't behave that way either, or at least
> not without some strong justification.

But the features disallowed by the L0 have to be viewed as unimplemented=20
by the hardware so the bits would be reserved, so according to=20
architecture they actually are allowed to return zero.

That's not my concern though, and I do agree it is a bit odd. I don't=20
have a problem with leaving the FC field value unchanged.

I think at least printing a warning for unimplemented bits would be good=20
though.

Thanks,
Nick
