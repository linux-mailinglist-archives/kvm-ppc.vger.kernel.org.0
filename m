Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CC1410B88
	for <lists+kvm-ppc@lfdr.de>; Sun, 19 Sep 2021 14:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhISMW3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 19 Sep 2021 08:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhISMW3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 19 Sep 2021 08:22:29 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1FAC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 19 Sep 2021 05:21:04 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HC6H06qYtz9sXV;
        Sun, 19 Sep 2021 22:21:00 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, Eirik Fuller <efuller@redhat.com>
In-Reply-To: <20210908101718.118522-1-npiggin@gmail.com>
References: <20210908101718.118522-1-npiggin@gmail.com>
Subject: Re: [PATCH v1 1/2] powerpc/64s: system call rfscv workaround for TM bugs
Message-Id: <163205402834.1052045.16310536368273936213.b4-ty@ellerman.id.au>
Date:   Sun, 19 Sep 2021 22:20:28 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 8 Sep 2021 20:17:17 +1000, Nicholas Piggin wrote:
> The rfscv instruction does not work correctly with the fake-suspend mode
> in POWER9, which can end up with the hypervisor restoring an incorrect
> checkpoint.
> 
> Work around this by setting the _TIF_RESTOREALL flag if a system call
> returns to a transaction active state, causing rfid to be used instead
> of rfscv to return, which will do the right thing. The contents of the
> registers are irrelevant because they will be overwritten in this case
> anyway.
> 
> [...]

Applied to powerpc/fixes.

[1/2] powerpc/64s: system call rfscv workaround for TM bugs
      https://git.kernel.org/powerpc/c/ae7aaecc3f2f78b76ab3a8d6178610f55aadfa56
[2/2] KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers
      https://git.kernel.org/powerpc/c/267cdfa21385d78c794768233678756e32b39ead

cheers
