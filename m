Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9374F3CA
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Apr 2019 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfD3KL4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Apr 2019 06:11:56 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50937 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfD3KL4 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:56 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tckx63cWz9sBr; Tue, 30 Apr 2019 20:11:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619113; bh=/3cVNERTeFNHsUu9N/NoL+9iM4miE3OQ/3mWOShCetQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YADHNTpgxSe0EKuGzE4A8KBo387NkTzsK47lXBVfvDMfrxrylvn1IrLnm+Ic3Hsht
         66jPJh0khrpXf8dcgZDLjItpY1WuMYUr3eJBZLlf0JZeaRqJTffklbU4yccaqyLoFY
         WXlPUtcNffp2rnPfd0VSRjzpyocOj3HxoOCsAHwIc3woDjwTdq25lco5x/s+nCZIHa
         gDkxC0BKknl85ITtZs3JL6Nch17VFz/OwqW9rHhK2RqKMO5FpesErdsk1AVyrfwq37
         XUOSCSm0N59pkDi2jjKXhKLR9nqHKglGp95cnJH3kTIwA26uZwNlsquKmg77jnsxRE
         tJQKc4QtRhscg==
Date:   Tue, 30 Apr 2019 20:03:23 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Palmer Dabbelt <palmer@sifive.com>
Cc:     benh@kernel.crashing.org, mpe@ellerman.id.au,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: smb->smp comment fixup
Message-ID: <20190430100323.GF32205@blackberry>
References: <20190425195339.12609-1-palmer@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425195339.12609-1-palmer@sifive.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Apr 25, 2019 at 12:53:39PM -0700, Palmer Dabbelt wrote:
> I made the same typo when trying to grep for uses of smp_wmb and figured
> I might as well fix it.
> 
> Signed-off-by: Palmer Dabbelt <palmer@sifive.com>

Thanks, patch applied to my kvm-ppc-next tree.

Paul.
