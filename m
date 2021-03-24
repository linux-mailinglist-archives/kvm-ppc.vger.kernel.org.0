Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09720347DA5
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Mar 2021 17:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhCXQ0R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 24 Mar 2021 12:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhCXQZx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 24 Mar 2021 12:25:53 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636E8C061763
        for <kvm-ppc@vger.kernel.org>; Wed, 24 Mar 2021 09:25:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h8so1200619plt.7
        for <kvm-ppc@vger.kernel.org>; Wed, 24 Mar 2021 09:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=4x0pTl7vu9u+HKRmu4XTYvejN4k4GGeXIB+STZwV3gU=;
        b=h9oN+J12WVhNriNkY7c/yOu/Z4dUkL9/M+vFUkvaqxw/qhHQ558xDA2Voc2vm79bCT
         IHMpEnJucyJJ6h5t4jU2nbooCQHPvSyIEl1Wg1++4ilwxMLmmCSwrW7mi2zwqkXJaGRP
         ebbdBtG52+EjmSzOsyj9BS6lSn2y+ziTm5Ku+zKpNM30pIQQ6WjsWILwBY6/nX/2x9T1
         FH9XlPWl6+jij5SkPzEK2QGWdg8NDNvw/fKjIjXslrMKGS2CPPm2jGk7dwtnS+KtpFAb
         o1ZIOtHspDM3BScaP7ok1sg7D6ixRV4tc25tujB/d1kD/ljzKoM2tgPMmAij5giZC3db
         MG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=4x0pTl7vu9u+HKRmu4XTYvejN4k4GGeXIB+STZwV3gU=;
        b=SHmzlw42hhOWVTepgXK4k8JGKB7KAdPjJCzWUMnEe4sHg5sQbZ6eIe+hOXMWrEqVcZ
         XW2uX1SbSqJRNIEIGqDhfqdpVZwD2VxtCBBHU0qmS/R3iqerDegPWgX0eSILhRcuRaWQ
         J93p/JnC2zUq7FU3BodW38GxvleiDH68IbmfChW+Nc1MEmhj6s/s8LnDz0Fu5b75ZoRe
         qa48l/Ozl4avyUkLilVU2rQayMo5ZAXRvjfMa5M6SKOuDlkFuLvh4gZuvGzRLiO2Kalz
         y9S4DTAVkavUzuTgYa1k/PfzFFjR1Yq8p0HQIxvO/y0N4BBgPMBmoZNpqMxzVSwM/3Zw
         /r4A==
X-Gm-Message-State: AOAM533GxJp3k5bMfbmn1JdtQttBJVOa1yEozgw8A7WjQwYEgMMyIH/U
        qHYxaMupG9nQgSttcgB//eE6N1moyEw=
X-Google-Smtp-Source: ABdhPJzlEk3keginYgtSSKRq6i1wwXwj0Tvn8NcU4HEefS9F6DT4HNdJ4jsyySY7QOBkRMtZjdnFww==
X-Received: by 2002:a17:902:d888:b029:e6:1ca1:d7f9 with SMTP id b8-20020a170902d888b02900e61ca1d7f9mr4470860plz.17.1616603151443;
        Wed, 24 Mar 2021 09:25:51 -0700 (PDT)
Received: from localhost ([1.132.216.217])
        by smtp.gmail.com with ESMTPSA id a13sm2836081pgm.43.2021.03.24.09.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 09:25:50 -0700 (PDT)
Date:   Thu, 25 Mar 2021 02:25:43 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 00/46] KVM: PPC: Book3S: C-ify the P9 entry/exit code
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1616602979.lxwl22jihw.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of March 23, 2021 11:02 am:
> I think enough changes and fixes have gone in since last round
> to repost.
>=20
> I put a git tree here to make things easier to get.
>=20
> https://github.com/npiggin/linux/tree/kvm-in-c-2

I just pushed a new tree https://github.com/npiggin/linux/tree/kvm-in-c-3

This mainly fixes up the compile error with older binutils and PR=3D1=20
hcall reflection into guest for PR KVM. Haven't been able to completely=20
test PR KVM because of unrelated connectivity issues but at least the
PR=3D1 syscall reflection is working again.

Thanks,
Nick
