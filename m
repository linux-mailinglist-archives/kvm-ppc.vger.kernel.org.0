Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6A110C9D2
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Nov 2019 14:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfK1Nt7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Nov 2019 08:49:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25881 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726648AbfK1Nt5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Nov 2019 08:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574948997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YGu0d5nRzTCOt5B0VpP7FKFZ/eZdcWkMoSbZy1tSSR8=;
        b=Oo5K+xKxsQHiESbFBSSdf16QrXYyDY+bbW1ptoY+rfLM6lUyuDZxgFrmwFzHhlqH1yp/9M
        84gFPKvKazDuTz5tkKHkyzrse0hQefg2px5AaTdEa4SEGlPVzPen8haOi+8btBNLqYYHx1
        4IKsYehKhLzFVvgcxXVYyNgIM76M5eI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-IbxjpUAOPQKukKkZ10Cxrw-1; Thu, 28 Nov 2019 08:49:46 -0500
X-MC-Unique: IbxjpUAOPQKukKkZ10Cxrw-1
Received: by mail-wr1-f70.google.com with SMTP id q12so13922856wrr.3
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Nov 2019 05:49:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=ZmGe5n3O3M6DV1wf0Ps1dVbZi2eWgc0G03f2LgnxlkE=;
        b=OnpoxJB1rWkrMPOHNT9GmnnnVXqZZEzuMUhMN+3NN77N2aau4PMlis2tplupZa96Yu
         MHJCKXAfQHZO/jjOHJ6C72Gd9eoikIJ1voKDvkUZHJc/QG71LrOSZkquXXnUPeIgD5JB
         DyxdCJqlAldd5zmYlPysaFV6xdP9OIKFArLTABeV4Z9GS4g3eb3LD6KovvIKGgprjEGH
         a0H/RzvENsR722QZqACd5chtvNWU1tgat7iPzaLeEqcn+zkO2vzGcV9hjnfS5i2zE4cx
         satsV1hCfy43NX+6iiKA/Rjw1On8gRiAQ7GnyZfQu9W7K4gFo1kW0ZbSLljUXy28PCG1
         zyuQ==
X-Gm-Message-State: APjAAAVdApkLVGrhiIwDDMyQmumTWQ79F/oT1ugvnCEBZkmot/xp62zF
        FKTtwxemgWrkZg8FZ5tlXV0HsSMyDZq/V0NJljQY1zJc7C4998SoLRQ5/RATkLwEbC7BXDey0TV
        EOppMGu3luBJgf+iyeQ==
X-Received: by 2002:a5d:4b05:: with SMTP id v5mr47422466wrq.210.1574948985554;
        Thu, 28 Nov 2019 05:49:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqyo7HcXazQ+g8Uub3wjMyHoxjSedTWzFyFIa+sdDQUlYNKyn1oJh+oqfh+jQB6/ujGwKhd9qg==
X-Received: by 2002:a5d:4b05:: with SMTP id v5mr47422451wrq.210.1574948985283;
        Thu, 28 Nov 2019 05:49:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:459f:99a9:39f1:65ba? ([2001:b07:6468:f312:459f:99a9:39f1:65ba])
        by smtp.gmail.com with ESMTPSA id u69sm11266129wmu.39.2019.11.28.05.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2019 05:49:44 -0800 (PST)
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
To:     Leonardo Bras <leonardo@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
 <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
 <20191126171416.GA22233@linux.intel.com>
 <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
 <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
 <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
 <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
 <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
 <20191127194757.GI22227@linux.intel.com>
 <103b290917221baa10194c27c8e35b9803f3cafa.camel@linux.ibm.com>
 <41fe3962ce1f1d5f61db5f5c28584f68ad66b2b1.camel@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a924cb9c-8354-23fe-1052-8ad564edad7f@redhat.com>
Date:   Thu, 28 Nov 2019 14:49:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <41fe3962ce1f1d5f61db5f5c28584f68ad66b2b1.camel@linux.ibm.com>
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2EOQw14S6yWgOPBTzrBp0a23SVveOhNfL"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2EOQw14S6yWgOPBTzrBp0a23SVveOhNfL
Content-Type: multipart/mixed; boundary="9jBDL15xpbJKsgN8Nju6MIyr9G8TyK9WX"

--9jBDL15xpbJKsgN8Nju6MIyr9G8TyK9WX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 27/11/19 22:57, Leonardo Bras wrote:
> But on the above case, kvm_put_kvm{,_no_destroy}() would be called
> with refcount =3D=3D 1, and if reorder patch is applied, it would not cau=
se
> any use-after-free error, even on kvm_put_kvm() case.

I think this is what you're missing: kvm_put_kvm_no_destroy() does not
protect against bugs in the code that uses it.  It protect against bugs
_elsewhere_.

Therefore, kvm_put_kvm_no_destroy() is always a better choice when
applicable, because it turns bugs in _other parts of the code_ from
use-after-free to WARN+leak.

Paolo


--9jBDL15xpbJKsgN8Nju6MIyr9G8TyK9WX--

--2EOQw14S6yWgOPBTzrBp0a23SVveOhNfL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl3f0HYACgkQv/vSX3jH
roMNEgf/Q3reWDs1tODfTThvp6Wza8S6DSLbioMx7K9JBrW2K7M+ZKsrXRV/j10j
XPPHsCVx7KEp5cxNtKWt5AFdfaNJ/QRvb1dE8op90d/i++uYG8lh2ok68zlgd+oQ
8dGrnGPhFNvp1vqxkkz0ca6tuLnEXRDc/UfgZLiXqHN7WmC4T/75QfRY5CZmQpbs
2IR5QsXKH9yIS18phyWOrLUCRpteBpAlAiUGawDN9XCE61O6ddHQkJvA2jk4fOZ2
qzybstGlwM5hK3i/FsIEZZiKJPPNT+Pg2+w8Xugbtw+zv57sG5uNgHpr2DVm+BxP
8F1nuo5Csxfr0tgJH2/109OJ0/Mo7g==
=65Gz
-----END PGP SIGNATURE-----

--2EOQw14S6yWgOPBTzrBp0a23SVveOhNfL--

