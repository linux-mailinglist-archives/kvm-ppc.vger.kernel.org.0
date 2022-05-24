Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F23B532845
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 May 2022 12:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiEXKyC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 May 2022 06:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbiEXKyC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 May 2022 06:54:02 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766675D5C7
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 03:54:00 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6rfZ54jXz4ySb;
        Tue, 24 May 2022 20:53:58 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     npiggin@gmail.com, kvm-ppc@vger.kernel.org
In-Reply-To: <20220328215831.320409-1-farosas@linux.ibm.com>
References: <20220328215831.320409-1-farosas@linux.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix vcore_blocked tracepoint
Message-Id: <165338951438.1711920.10689960042369328588.b4-ty@ellerman.id.au>
Date:   Tue, 24 May 2022 20:51:54 +1000
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

On Mon, 28 Mar 2022 18:58:31 -0300, Fabiano Rosas wrote:
> We removed most of the vcore logic from the P9 path but there's still
> a tracepoint that tried to dereference vc->runner.
> 
> 

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: Fix vcore_blocked tracepoint
      https://git.kernel.org/powerpc/c/ad55bae7dc364417434b69dd6c30104f20d0f84d

cheers
