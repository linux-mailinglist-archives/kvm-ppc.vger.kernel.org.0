Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E513CF3D5
	for <lists+kvm-ppc@lfdr.de>; Tue, 20 Jul 2021 07:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347100AbhGTEY2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 20 Jul 2021 00:24:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1346226AbhGTEYW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 20 Jul 2021 00:24:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K53NJ9019968;
        Tue, 20 Jul 2021 01:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YIlbonzyYfr48j+9mltYbtpEvxW+h5RKDMRsYj4+yp8=;
 b=bD8fD32/SMHgXFWkCZxZCzTI5HHc1jN9Lu64hUj1qXnSp2JdP2nHKV/mR7gmu2yQUhqC
 C8Ls0kvfnjPB60HM2uSmfmFmWsNhBZLskfteK/ntAIRIaF/kZFIieLI28D4TJ/wCsOCX
 WPBsSRbYF/QvNj2wPZj7XMMHEpsNSKmNhCdNF4lDffvWU9nrH52heYs/B6/4yX2oJ/lm
 GzNSVy5LOxBuVEq/foMNwavbZZWu1jFV6/VKDwk3IezmyKtcaaqcYKUFjYyAzLQJWXuJ
 PGIWziQTkB0/0dieRZqILEkEOhZGBye1BzJpjEkuVz41jfsINQ5FrKQ4aUf66tqP4xsw nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39wny8jj8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 01:04:29 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16K53O8T020069;
        Tue, 20 Jul 2021 01:04:29 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39wny8jj81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 01:04:29 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16K52cfK014061;
        Tue, 20 Jul 2021 05:04:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 39vng70p9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 05:04:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16K54PQH26673532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 05:04:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6348FAE059;
        Tue, 20 Jul 2021 05:04:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F874AE051;
        Tue, 20 Jul 2021 05:04:23 +0000 (GMT)
Received: from [9.199.45.122] (unknown [9.199.45.122])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Jul 2021 05:04:23 +0000 (GMT)
Subject: Re: [PATCH v5 1/1] powerpc/pseries: Interface to represent PAPR
 firmware attributes
To:     Fabiano Rosas <farosas@linux.ibm.com>, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, pratik.r.sampat@gmail.com
References: <20210719093250.41405-1-psampat@linux.ibm.com>
 <20210719093250.41405-2-psampat@linux.ibm.com> <87fswa2k93.fsf@linux.ibm.com>
From:   Pratik Sampat <psampat@linux.ibm.com>
Message-ID: <de3c5540-2a07-8373-57a2-a89e3d304413@linux.ibm.com>
Date:   Tue, 20 Jul 2021 10:34:22 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87fswa2k93.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ssVwGSroUKkgqBVXNDRQTUb2Yw54hczw
X-Proofpoint-GUID: 4u1S___xB0Dar2DtbsH4-eXC1GRUkLB7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_01:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200028
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 20/07/21 12:39 am, Fabiano Rosas wrote:
> "Pratik R. Sampat" <psampat@linux.ibm.com> writes:
>
>> +	pgs = kcalloc(num_attrs, sizeof(*pgs), GFP_KERNEL);
>> +	if (!pgs)
>> +		goto out;
>> +
>> +	papr_kobj = kobject_create_and_add("papr", firmware_kobj);
>> +	if (!papr_kobj) {
>> +		pr_warn("kobject_create_and_add papr failed\n");
>> +		goto out_pgs;
>> +	}
>> +
>> +	esi_kobj = kobject_create_and_add("energy_scale_info", papr_kobj);
>> +	if (!esi_kobj) {
>> +		pr_warn("kobject_create_and_add energy_scale_info failed\n");
>> +		goto out_kobj;
>> +	}
>> +
>> +	for (idx = 0; idx < num_attrs; idx++) {
>> +		bool show_val_desc = true;
>> +
>> +		pgs[idx].pg.attrs = kcalloc(MAX_ATTRS + 1,
>> +					    sizeof(*pgs[idx].pg.attrs),
>> +					    GFP_KERNEL);
>> +		if (!pgs[idx].pg.attrs) {
>> +			for (i = idx - 1; i >= 0; i--)
>> +				kfree(pgs[i].pg.attrs);
> What about the pg.name from the previous iterations?
>
>> +			goto out_ekobj;
>> +		}
>> +
>> +		pgs[idx].pg.name = kasprintf(GFP_KERNEL, "%lld",
>> +					     be64_to_cpu(esi_attrs[idx].id));
>> +		if (pgs[idx].pg.name == NULL) {
>> +			for (i = idx; i >= 0; i--)
>> +				kfree(pgs[i].pg.attrs);
> Here too.
>
> You could just 'goto out_pgattrs' in both cases.

Yeah, you're right. I may have over-complicated the free, in case of
failure in both the cases above I could just free from "out_pgattrs"
with no issues

>> +			goto out_ekobj;
>> +		}
>> +		/* Do not add the value description if it does not exist */
>> +		if (strnlen(esi_attrs[idx].value_desc,
>> +			    sizeof(esi_attrs[idx].value_desc)) == 0)
>> +			show_val_desc = false;
>> +
>> +		if (add_attr_group(be64_to_cpu(esi_attrs[idx].id), &pgs[idx],
>> +				   show_val_desc)) {
>> +			pr_warn("Failed to create papr attribute group %s\n",
>> +				pgs[idx].pg.name);
>> +			goto out_pgattrs;
>> +		}
>> +	}
>> +
>> +	kfree(esi_buf);
>> +	return 0;
>> +
>> +out_pgattrs:
>> +	for (i = 0; i < num_attrs ; i++) {
>> +		kfree(pgs[i].pg.attrs);
>> +		kfree(pgs[i].pg.name);
>> +	}
>> +out_ekobj:
>> +	kobject_put(esi_kobj);
>> +out_kobj:
>> +	kobject_put(papr_kobj);
>> +out_pgs:
>> +	kfree(pgs);
>> +out:
>> +	kfree(esi_buf);
>> +
>> +	return -ENOMEM;
>> +}
>> +
>> +machine_device_initcall(pseries, papr_init);

