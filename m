Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBBD10D990
	for <lists+kvm-ppc@lfdr.de>; Fri, 29 Nov 2019 19:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfK2SUc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 29 Nov 2019 13:20:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43573 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727120AbfK2SUc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 29 Nov 2019 13:20:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575051631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RzJvSlB/rfjy8jfdIVuXjQ5PpaWo8u1a5rnrJhVFPI=;
        b=YiTHj+ABOay1NfI2wARJGmdZXWOGAkJ0sXkcXOzF4PyJjB2zwNpK9hHlY3ZPlSeO4y1aTx
        c9nq+YAF7mkklMi+1lNXKhIqMm+iXiyA+CQ2Bs4vsY0wTLA1xsaZhot2EcbeY90yh2SU8F
        Va8DTBTp1hMo28E0BAEH0eiuy30wlHE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-lGvlDXanPeOFcMQip0PuqA-1; Fri, 29 Nov 2019 13:20:29 -0500
Received: by mail-wr1-f69.google.com with SMTP id q6so15947118wrv.11
        for <kvm-ppc@vger.kernel.org>; Fri, 29 Nov 2019 10:20:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3RzJvSlB/rfjy8jfdIVuXjQ5PpaWo8u1a5rnrJhVFPI=;
        b=QTvxg7yQKd0bcibnle7JZAYnHCIVMNq40qrOpoMyt8Aw0sPPbDEi8kpGLZq4EdSilt
         dTVVZthYMgUFRUGCRC0jK3emaTq56DB8vEoT8lMANP4qyPqyGbXfAEjye+AFNx1S4kqQ
         hfDylWQbbcPWGf+AY+3xzb9Ab7x6E6XHBKXC9PFE09g1/J5crLb4nRwR+KPA3N+Hryks
         4yTYNOtH2PZ1wveOq4qMwfKQoA/BIVepgL9xNng4ObdKXmhqv9GLzvzKykAYYINA4DVM
         aAet5LwH8E7GoMGtF/zUlu8HRWiw22IRGZa6gfi5N5wL5CB8bAv7V9koDoqdDMIMO3aY
         Zbrw==
X-Gm-Message-State: APjAAAU9b/Rc8F3G0Hj2tan94/mv7bu3RJdPrVk5lZ2GlHTA9Sb9D+eP
        cm3KDSy2/tNMcwc5Ru57nbAhI5aTDBVpO9bfpO/pFDK/61JJ9qtY65pzv1qm7QrJe0+0U9QQYML
        RCJ+iPBUIkwclryFqQQ==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr21563820wrx.304.1575051628226;
        Fri, 29 Nov 2019 10:20:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8E3ISRX1T2z8HQmp+PdaIrBNIJ9SYct+UrLVrq0/rqXXkSpqXcyBLTRTYHsfQ5TzYkCty1A==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr21563796wrx.304.1575051627946;
        Fri, 29 Nov 2019 10:20:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id x13sm13853120wmc.19.2019.11.29.10.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 10:20:27 -0800 (PST)
Subject: Re: [GIT PULL v2] Please pull my kvm-ppc-uvmem-5.5-2 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>
References: <20191126052455.GA2922@oak.ozlabs.ibm.com>
 <20191128232528.GA12171@oak.ozlabs.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <91f667ee-0464-35f2-31cd-0bc661bf9edc@redhat.com>
Date:   Fri, 29 Nov 2019 19:20:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191128232528.GA12171@oak.ozlabs.ibm.com>
Content-Language: en-US
X-MC-Unique: lGvlDXanPeOFcMQip0PuqA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 29/11/19 00:25, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-uvmem-5.5-2

Pulled, thanks.

Paolo

