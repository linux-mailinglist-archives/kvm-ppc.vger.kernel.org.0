Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF35E442CEA
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Nov 2021 12:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhKBLmG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Nov 2021 07:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhKBLl1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Nov 2021 07:41:27 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4098C061764
        for <kvm-ppc@vger.kernel.org>; Tue,  2 Nov 2021 04:38:50 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hk7G148Xjz4xdc;
        Tue,  2 Nov 2021 22:38:49 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20211004145749.1331331-1-npiggin@gmail.com>
References: <20211004145749.1331331-1-npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: H_ENTER filter out reserved HPTE[B] value
Message-Id: <163584789016.1845480.2757100550456404160.b4-ty@ellerman.id.au>
Date:   Tue, 02 Nov 2021 21:11:30 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 5 Oct 2021 00:57:49 +1000, Nicholas Piggin wrote:
> The HPTE B field is a 2-bit field with values 0b10 and 0b11 reserved.
> This field is also taken from the HPTE and used when KVM executes
> TLBIEs to set the B field of those instructions.
> 
> Disallow the guest setting B to a reserved value with H_ENTER by
> rejecting it. This is the same approach already taken for rejecting
> reserved (unsupported) LLP values. This prevents the guest from being
> able to induce the host to execute TLBIE with reserved values, which
> is not known to be a problem with current processors but in theory it
> could prevent the TLBIE from working correctly in a future processor.
> 
> [...]

Applied to powerpc/next.

[1/1] KVM: PPC: Book3S HV: H_ENTER filter out reserved HPTE[B] value
      https://git.kernel.org/powerpc/c/322fda0405fecaaa540b0fa90393830aaadaf420

cheers
