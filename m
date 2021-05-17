Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5586D38258F
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 May 2021 09:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEQHoE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 May 2021 03:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhEQHn6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 May 2021 03:43:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F947C061573
        for <kvm-ppc@vger.kernel.org>; Mon, 17 May 2021 00:42:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q6so3192858pjj.2
        for <kvm-ppc@vger.kernel.org>; Mon, 17 May 2021 00:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=P/KdnP4nwgl0oNC3j6na2E4K0eFgZ4XpiZ9Ts+1Vwkg=;
        b=UFtpsgVRGB0Qo1PD+jv40tyDuXtKoAAfK7BXYc2ZLOZIyAv0Tz1p19YIxA/iHmRqlR
         fxFIy9mUSCDgmDdT5o11cfH7hRLSf78v/op/Hno3zYLTa9pDmrjahqZsuCYMuSfWE07r
         GEqGuoHPZ586A8BvLoRSj0sZ5+3HuAzxOUQ6wnFQGSirgMFfF4EnW+ajOKCtLfcSHeiI
         TtFBnxVkVCz7wVDl5dgVp7HbDAIXM13dTolEg4fnM2ighezc7DmOhy/uMcYTRzzu4V4p
         m04/e44w2UlIcy0uHgIK+J5F17arytBXkZZb5OlDpO3rm4z1HbQzyhEuLd3cIsg0xqIx
         yYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=P/KdnP4nwgl0oNC3j6na2E4K0eFgZ4XpiZ9Ts+1Vwkg=;
        b=NmgcYmD2hcQqEiqz4w9uKfd9ohUU3XM2wcGfud3VdHCQ1ziQ5DtYWY4o+PP5DKdDD8
         04+83oDmcHPAhGfrOvojUNq1nVJVqwFr8HfSq2Vm0zJ+iN7rWzBI2vLPxzrNv1n5PNvp
         CB/4ARZHmLTegIyiWmfmtJoXGfppVwSbkYsmoRGLNtmgBV1WsLqNnDqPLdzVFMIeJMFp
         tt/3BR1CiPCUIsT7xi8IecZqYzSwFrrCgH+9vDYAGUFSw4F0Fb0RkK4JGfhIxz74tEIA
         kurhm5mEZXQpoB7Kg//em0D728Q1t4qws89pMXKqTvIuBbDc7vLy9M9umUR5XKR73Zni
         Kldg==
X-Gm-Message-State: AOAM530+QJwFbLVfPQ5EgwgbnRcrWljfswMCcPtZJqKTFRyGssLNA3oQ
        SM+T7zX16g3LMJlQPLl+5w9NalPWd10=
X-Google-Smtp-Source: ABdhPJxAaQNPBams28CP2wyD2U67alh+QHySRu7vhtRqy2rC9h5cjvymDC95D9xFLOkrdHYRbNitjQ==
X-Received: by 2002:a17:90a:de09:: with SMTP id m9mr63977638pjv.41.1621237348803;
        Mon, 17 May 2021 00:42:28 -0700 (PDT)
Received: from localhost (14-201-155-8.tpgi.com.au. [14.201.155.8])
        by smtp.gmail.com with ESMTPSA id 125sm2429130pfg.52.2021.05.17.00.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 00:42:28 -0700 (PDT)
Date:   Mon, 17 May 2021 17:42:23 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        Christian Zigotzky <info@xenosoft.de>,
        mad skateman <madskateman@gmail.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>
References: <04526309-4653-3349-b6de-e7640c2258d6@xenosoft.de>
        <34617b1b-e213-668b-05f6-6fce7b549bf0@xenosoft.de>
        <9af2c1c9-2caf-120b-2f97-c7722274eee3@csgroup.eu>
        <199da427-9511-34fe-1a9e-08e24995ea85@xenosoft.de>
In-Reply-To: <199da427-9511-34fe-1a9e-08e24995ea85@xenosoft.de>
MIME-Version: 1.0
Message-Id: <1621236734.xfc1uw04eb.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Christian Zigotzky's message of May 15, 2021 11:46 pm:
> On 15 May 2021 at 12:08pm Christophe Leroy wrote:
>>
>>
>> Le 15/05/2021 =C3=A0 11:48, Christian Zigotzky a =C3=A9crit=C2=A0:
>>> Hi All,
>>>
>>> I bisected today [1] and the bisecting itself was OK but the=20
>>> reverting of the bad commit doesn't solve the issue. Do you have an=20
>>> idea which commit could be resposible for this issue? Maybe the=20
>>> bisecting wasn't successful. I will look in the kernel git log. Maybe=20
>>> there is a commit that affected KVM HV on FSL P50x0 machines.
>>
>> If the uImage doesn't load, it may be because of the size of uImage.
>>
>> See https://github.com/linuxppc/issues/issues/208
>>
>> Is there a significant size difference with and without KVM HV ?
>>
>> Maybe you can try to remove another option to reduce the size of the=20
>> uImage.
> I tried it but it doesn't solve the issue. The uImage works without KVM=20
> HV in a virtual e5500 QEMU machine.

Any more progress with this? I would say that bisect might have just
been a bit unstable and maybe by chance some things did not crash so
it's pointing to the wrong patch.

Upstream merge of powerpc-5.13-1 was good and powerpc-5.13-2 was bad?

Between that looks like some KVM MMU rework. You could try the patch
before this one b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU=20
notifier callbacks"). That won't revert cleanly so just try run the
tree at that point. If it works, test the patch and see if it fails.

Thanks,
Nick
