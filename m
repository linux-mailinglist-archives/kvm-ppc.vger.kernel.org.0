Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3256C8EC
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Jul 2022 12:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiGIKSL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 9 Jul 2022 06:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGIKSK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 9 Jul 2022 06:18:10 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E91E3CBF9
        for <kvm-ppc@vger.kernel.org>; Sat,  9 Jul 2022 03:18:10 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lg5h01cmVz4xvG;
        Sat,  9 Jul 2022 20:18:08 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org
In-Reply-To: <20220614165204.549229-1-farosas@linux.ibm.com>
References: <20220614165204.549229-1-farosas@linux.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: tracing: Add missing hcall names
Message-Id: <165736166961.12236.1738268896946645042.b4-ty@ellerman.id.au>
Date:   Sat, 09 Jul 2022 20:14:29 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 14 Jun 2022 13:52:04 -0300, Fabiano Rosas wrote:
> The kvm_trace_symbol_hcall macro is missing several of the hypercalls
> defined in hvcall.h.
> 
> Add the most common ones that are issued during guest lifetime,
> including the ones that are only used by QEMU and SLOF.
> 
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: tracing: Add missing hcall names
      https://git.kernel.org/powerpc/c/0df01238b8aa300cbc736e7ec433d201a76036f3

cheers
