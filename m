Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC65656C8EA
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Jul 2022 12:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiGIKSK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 9 Jul 2022 06:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGIKSJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 9 Jul 2022 06:18:09 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E963CBFA
        for <kvm-ppc@vger.kernel.org>; Sat,  9 Jul 2022 03:18:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lg5gs0QWjz4xXD;
        Sat,  9 Jul 2022 20:18:01 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm-ppc@vger.kernel.org
In-Reply-To: <20220622055235.1139204-1-aik@ozlabs.ru>
References: <20220622055235.1139204-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Book3s: Fix warning about xics_rm_h_xirr_x
Message-Id: <165736166219.12236.403684583193029179.b4-ty@ellerman.id.au>
Date:   Sat, 09 Jul 2022 20:14:22 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 22 Jun 2022 15:52:35 +1000, Alexey Kardashevskiy wrote:
> This fixes "no previous prototype":
> 
> arch/powerpc/kvm/book3s_hv_rm_xics.c:482:15:
> warning: no previous prototype for 'xics_rm_h_xirr_x' [-Wmissing-prototypes]
> 
> Reported by the kernel test robot.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3s: Fix warning about xics_rm_h_xirr_x
      https://git.kernel.org/powerpc/c/a784101f77b1bef4b40f4ad68af3f54fcfa5321b

cheers
